//
//  SSEService.swift
//  SafeVision
//
//  Created by KimDogyung on 8/23/25.
//

import Foundation
import Combine
import Alamofire

protocol SSEServiceProtocol {
    var eventPublisher: AnyPublisher<ServerEvent, Error> { get }
    func connect(to url: URL)
    func disconnect()
}

class AlamofireSSEService: SSEServiceProtocol {

    
    private let eventSubject = PassthroughSubject<ServerEvent, Error>() // inner publisher
    var eventPublisher: AnyPublisher<ServerEvent, Error> { // external publisher
        eventSubject.eraseToAnyPublisher()
    }
    
    private var streamRequest: DataStreamRequest?

    // MARK: - Public Methods

    func connect(to url: URL) {
        // 이미 연결된 경우 중복 연결 방지
        guard streamRequest == nil else { return }
        
        // SSE를 위한 표준 헤더 설정
        let headers: HTTPHeaders = [
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
            "Connection": "keep-alive"
        ]

        // streamRequest를 사용하여 SSE 엔드포인트에 연결합니다.
        streamRequest = AF.streamRequest(url, method: .get, headers: headers)
            // stream 이벤트 핸들러
            .responseStream { [weak self] stream in
                switch stream.event {
                // 스트림 데이터가 도착했을 때
                case .stream(let result):
                    switch result {
                    case .success(let data):
                        if let eventString = String(data: data, encoding: .utf8) {
                            self?.parse(eventString: eventString)
                        }
                    case .failure(let error):
                        print("🚨 AlamofireSSEService: Stream error: \(error)")
                        self?.eventSubject.send(completion: .failure(error))
                    }
                    // 스트림이 종료되었을 때 (성공/실패 모두)
                case .complete(let completion):
                    print("🏁 AlamofireSSEService: Stream completed.")
                    if let error = completion.error {
                        // 에러가 있다면 subject에 전파
                        self?.eventSubject.send(completion: .failure(error))
                    } else {
                        // 정상 종료
                        self?.eventSubject.send(completion: .finished)
                    }
                    self?.disconnect()
                }
            }
        print("🔗 AlamofireSSEService: Connected to \(url.absoluteString)")
    }

    func disconnect() {
        streamRequest?.cancel()
        streamRequest = nil
        print("🔌 AlamofireSSEService: Disconnected.")
    }
    
    // MARK: - Private Helper
    
    private func parse(eventString: String) {
        let lines = eventString.components(separatedBy: .newlines)
        for line in lines {
            let prefix = "data: "
            if line.hasPrefix(prefix) {
                let jsonString = String(line.dropFirst(prefix.count))
                guard let jsonData = jsonString.data(using: .utf8) else { continue }

                do {
                    let decoder = JSONDecoder()
                    let serverEvent = try decoder.decode(ServerEvent.self, from: jsonData)
                    
                    // ViewModel이 UI를 업데이트 할 수 있도록 메인 스레드에서 이벤트 전달
                    DispatchQueue.main.async {
                        self.eventSubject.send(serverEvent)
                    }
                } catch {
                    print("🚨 AlamofireSSEService: JSON decoding error: \(error)")
                }
            }
        }
    }
}


//import Foundation
//import Combine
//
//class EventViewModel: ObservableObject {
//    
//    // MARK: - Properties
//    
//    @Published var receivedEvents: [ServerEvent] = []
//    @Published var isConnected: Bool = false
//    
//    private let sseService: SSEServiceProtocol
//    private var cancellables = Set<AnyCancellable>()
//    
//    // 의존성 주입(Dependency Injection)을 통해 SSEService를 받습니다.
//    // 이렇게 하면 테스트 시 Mock 객체를 주입하기 용이해집니다.
//    init(sseService: SSEServiceProtocol = SSEService()) {
//        self.sseService = sseService
//        subscribeToEvents()
//    }
//    
//    // MARK: - Public Methods
//    
//    func connect() {
//        // 실제 서버의 SSE 엔드포인트 URL로 변경해야 합니다.
//        guard let url = URL(string: "http://localhost:8080/sse") else {
//            print("🚨 ViewModel: Invalid URL")
//            return
//        }
//        sseService.connect(to: url)
//        isConnected = true
//    }
//    
//    func disconnect() {
//        sseService.disconnect()
//        isConnected = false
//    }
//    
//    // MARK: - Private Methods
//    
//    private func subscribeToEvents() {
//        sseService.eventPublisher
//            .sink(receiveCompletion: { completion in
//                // 에러 발생 시 처리
//                switch completion {
//                case .finished:
//                    print("ViewModel: Subscription finished.")
//                case .failure(let error):
//                    print("🚨 ViewModel: Subscription failed with error: \(error.localizedDescription)")
//                }
//                self.isConnected = false
//            }, receiveValue: { [weak self] newEvent in
//                // 새로운 이벤트를 받으면 배열의 맨 앞에 추가하여 최신순으로 표시
//                print("📦 ViewModel: Received new event - \(newEvent.message)")
//                self.receivedEvents.insert(newEvent, at: 0)
//            })
//            .store(in: &cancellables)
//    }
//}
