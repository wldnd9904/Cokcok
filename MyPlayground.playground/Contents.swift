import UIKit

var greeting = "Hello, playground"
var id:UUID = UUID()
print(id)
var ms:MatchSummary = generateRandomMatchSummaries(count: 1)[0]

for _ in 0...4 {
    let _: MotionDataChunk = MotionDataChunk(date: Date(), motiondata: [])
}
print(MotionDataChunk.counter)
MotionDataChunk.clearCounter()

for _ in 0...4 {
    let chunk: MotionDataChunk = MotionDataChunk(date: Date(), motiondata: [])
    print(chunk.seqNo)
}
