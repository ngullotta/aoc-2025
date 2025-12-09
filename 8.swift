import Foundation

let args = CommandLine.arguments
if args.count < 2 {
    exit(1)
}
let path = args[1] 
let url = URL(fileURLWithPath: path)


struct Point: Hashable {
    let x: Int64
    let y: Int64
    let z: Int64

    init(x: String, y: String, z: String) {
        self.x = Int64(x)!
        self.y = Int64(y)!
        self.z = Int64(z)!
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}

struct DSU {
    var parents: [Point: Point]
    var rank: [Point: Int]
    mutating func find(p: Point) -> Point {
        var pars: [Point] = []
        var curr = p
        var parent = self.parents[curr] ?? curr 
        while curr != parent {
            pars.append(curr)
            curr = parent 
            parent = self.parents[curr] ?? curr 
        }
        for par in pars {
            self.parents[par] = parent
        }
        return parent
    }

    mutating func union(p1: Point, p2: Point) {
        let par1 = self.find(p: p1)
        let par2 = self.find(p: p2)
        let rank1 = self.rank[par1] ?? 1
        let rank2 = self.rank[par2] ?? 1
        if rank1 > rank2 {
            self.parents[par2] = par1
            let _ = self.find(p: p2)
        } else {
            self.parents[par1] = par2
            let _ = self.find(p: p1)
        }
    }

    mutating func uniqueParents() -> Int {
        for p in self.parents {
            let _ = self.find(p: p.key)
        }
        return Set(self.parents.values).count
    }

    init(points: [Point]) {
        self.parents = [Point: Point]()
        self.rank = [Point: Int]()
        for p in points {
            self.parents[p] = p
            self.rank[p] = 1
        }
    }

}

func distance(p1: Point, p2: Point) -> Int64 {
    return ((p1.x - p2.x) * (p1.x - p2.x)) + ((p1.y - p2.y) * (p1.y - p2.y)) + ((p1.z - p2.z) * (p1.z - p2.z))
}

do {
    let contents = try String(contentsOf: url, encoding: .utf8)
    let lines: [String] = contents.split(separator: "\n").map{String($0)}
    let pointStrs: [[String]] = lines.map{line in 
        line.split(separator: ",").map{String($0)}
    }
    let points = pointStrs.map{Point(x: $0[0], y: $0[1], z: $0[2])}
    let NUM_ITERS = 1000
    var dsu = DSU(points: points)
    var closestPoints: [(p1: Point, p2: Point, d: Int64)] = []
    for i in (0 ..< points.count) {
        let p1 = points[i]
        for j in (i + 1 ..< points.count) {
            let p2 = points[j]
            let d = distance(p1: p1, p2: p2)
            closestPoints.append((p1: p1, p2: p2, d: d))
        }
    }
    closestPoints = closestPoints.sorted(by: {$0.d < $1.d})
    let closestPointsP1 = Array(closestPoints[0 ..< min(NUM_ITERS, closestPoints.count)])
    for closePoints in closestPointsP1 {
        dsu.union(p1: closePoints.p1, p2: closePoints.p2)
    }
    var circuits = [Point: Int]()
    for p in points {
        let par = dsu.find(p: p)
        circuits[par, default: 0] += 1
    }
    let circuitCounts = Array(circuits.values.sorted().reversed())
    if circuitCounts.count >= 3 {
        let res = circuitCounts[0] * circuitCounts[1] * circuitCounts[2]
        print("p1 \(res)")
    }
    

    var numConnectionsNeeded = 0
    var dsu2 = DSU(points: points)
    for closePoints in closestPoints {
        numConnectionsNeeded += 1
        dsu2.union(p1: closePoints.p1, p2: closePoints.p2)
        if dsu2.uniqueParents() == 1 {
            print("p2 \(closePoints.p1.x * closePoints.p2.x)")
            exit(0)
        }
    }

} catch {
    print("", error)
}