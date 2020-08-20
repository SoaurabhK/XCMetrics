//
//  PermutationAlgorithms.swift
//  XCMetrics
//
//  Created by Soaurabh Kakkar on 20/08/20.
//

import Foundation
import os.signpost

// MARK: Core
private let permutationOSLog = OSLog(subsystem: permutationLog.subsystem, category: permutationLog.category)

extension Int {
    var factorial: Int {
        guard self > 0 else { return 0 }
        return (1...self).reduce(1, *)
    }
}

extension Array {
    func split(by: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: by).map {
            guard count > $0 + by else {
                guard count > $0 else {
                    return []
                }
                return Array(self[$0..<count])
            }
            return Array(self[$0..<$0 + by])
        }
            .filter { !$0.isEmpty }
    }
}

extension RandomAccessCollection {
    func first(whereMagic predicate: (Iterator.Element) throws -> Bool) rethrows -> Iterator.Element? {

        for element in self {
            if try predicate(element) {
                return element
            }
        }
        return nil
    }
    
    func index(where predicate: (Iterator.Element) throws -> Bool) rethrows -> Index? {
        var i = startIndex
        while i <= endIndex {
            if try predicate(self[i]) {
                return i
            }
            i = index(after: i)
        }
        return nil
    }
}

extension Array {
    
    /// Reverses the elements of the collection within a given range of indices.
    ///
    /// - Parameter indices: A range of valid indices of the collection,
    ///  the elements of which will be reversed.
    ///
    mutating func reverse(indices: Range<Index>) {
        
        if indices.isEmpty { return }
        
        var low = indices.lowerBound
        var high = index(before: indices.upperBound)
        
        while low < high {
            swapAt(low, high)
            formIndex(after: &low)
            formIndex(before: &high)
        }
    }
}

extension Array {
    mutating func filterSingle(_ isIncluded: (Element) -> Bool) {
        for i in (0..<count) {
            if !isIncluded(self[i]) {
                remove(at: i)
                return
            }
        }
    }
    
    func slice(at: Int) -> (element: Element, rest: [Element]) {
        if at == 0 { return (first!, Array(self[1..<count])) }
        if at == count - 1 { return (last!, Array(self[0..<count - 1])) }
        return (self[at], Array(self[0..<at] + self[at + 1..<count]))
    }
    
    func generateSlices() -> [(element: Element, rest: [Element])] {
        return (0..<count).map { slice(at: $0) }
    }
}

// MARK: Permutations

extension Array where Element: Equatable {
    func permutations() -> [[Element]] {
        guard count != 0 else { return [] }
        guard count != 1 else { return [self] }
        var result: [[Element]] = []
        forEach { (element) in
            result.append(contentsOf: filter { $0 != element }.permutations().map { [element] + $0 } )
        }
        return result
    }
    
    func permutationsOptimized() -> [[Element]] {
        guard count != 0 else { return [] }
        guard count != 1 else { return [self] }
        return permutationsOptimizedRecursion(prepending: [])
    }
    
    func permutationsOptimized2() -> [[Element]] {
        guard count != 0 else { return [] }
        guard count != 1 else { return [self] }
        return permutationsOptimizedRecursion2(prepending: [])
    }
    
    func permutationsOptimized3() -> [[Element]] {
        guard count != 0 else { return [] }
        guard count != 1 else { return [self] }
        return permutationsOptimizedRecursion3(prepending: [])
    }
    
    func permutationsOptimized4() -> [[Element]] {
        guard count != 0 else { return [] }
        guard count != 1 else { return [self] }
        return permutationsOptimizedRecursion4(prepending: [])
    }
    
    private func permutationsOptimizedRecursion(prepending: [Element]) -> [[Element]] {
        guard count != 1 else { return [prepending + self] }
        var result: [[Element]] = []
        forEach { (element) in
            result.append(contentsOf: filter { $0 != element }.permutationsOptimizedRecursion(prepending: prepending + [element]) )
        }
        return result
    }
    
    private func permutationsOptimizedRecursion2(prepending: [Element]) -> [[Element]] {
        guard count != 1 else { return [prepending + self] }
        var result: [[Element]] = []
        forEach { (element) in
            let idx = index { $0 == element }!
            var copy = self
            copy.removeSubrange((idx...idx))
            result.append(contentsOf: copy.permutationsOptimizedRecursion2(prepending: prepending + [element]) )
        }
        return result
    }
    
    private func permutationsOptimizedRecursion3(prepending: [Element]) -> [[Element]] {
        guard count != 1 else { return [prepending + self] }
        var result: [[Element]] = []
        forEach { (element) in
            var copy = self
            copy.filterSingle { $0 != element }
            result.append(contentsOf: copy.permutationsOptimizedRecursion3(prepending: prepending + [element]) )
        }
        return result
    }
    
    private func permutationsOptimizedRecursion4(prepending: [Element]) -> [[Element]] {
        guard count != 1 else { return [prepending + self] }
        return generateSlices().map {
            $0.rest.permutationsOptimizedRecursion4(prepending: prepending + [$0.element]).flatMap { $0 }
        }
    }

    
    func nonRecursivePermutations() -> [[Element]]  {
        guard count != 0 else { return [] }
        guard count != 1 else { return [self] }
        let flattenSequenceLength = count * count.factorial
        let flattenSequence = (0..<flattenSequenceLength).map { return self[$0 % count] }
        return flattenSequence.split(by: count)
    }
    
    func knuthAlghorithmP() -> [[Element]] {
        var mutatingSelf = self
        var result: [[Element]] = []
        var c: [Int] = .init(repeating: 0, count: count)
        var o: [Int] = .init(repeating: 1, count: count)
        for _ in 0 ... count.factorial - 1 {
            result.append(mutatingSelf)
            var s = 0
            for j in (0 ... count - 1).reversed() {
                let q = c[j] + o[j]
                if q > -1 {
                    if q != j + 1 {
                        mutatingSelf.swapAt(j - c[j] + s, j - q + s)
                        c[j] = q
                        break
                    }
                    s = s + 1
                }
                o[j] = -o[j]
            }
        }
        return result
    }
}

extension Array where Element: Comparable {
    
    /// Replaces the array by the next permutation of its elements in lexicographic
    /// order.
    ///
    /// It uses the "Algorithm L (Lexicographic permutation generation)" from
    ///    Donald E. Knuth, "GENERATING ALL PERMUTATIONS"
    ///    http://www-cs-faculty.stanford.edu/~uno/fasc2b.ps.gz
    ///
    /// - Returns: `true` if there was a next permutation, and `false` otherwise
    ///   (i.e. if the array elements were in descending order).
    
    mutating func permute() -> Bool {
        
        // Nothing to do for empty or single-element arrays:
        if count <= 1 {
            return false
        }
        
        // L2: Find last j such that self[j] < self[j+1]. Terminate if no such j
        // exists.
        var j = count - 2
        while j >= 0 && self[j] >= self[j+1] {
            j -= 1
        }
        if j == -1 {
            return false
        }
        
        // L3: Find last l such that self[j] < self[l], then exchange elements j and l:
        var l = count - 1
        while self[j] >= self[l] {
            l -= 1
        }
        self.swapAt(j, l)
        
        // L4: Reverse elements j+1 ... count-1:
        var lo = j + 1
        var hi = count - 1
        while lo < hi {
            self.swapAt(lo, hi)
            lo += 1
            hi -= 1
        }
        return true
    }
    
    mutating func permuteFunctional() -> Bool {
        
        // Nothing to do for empty or single-element arrays:
        if count <= 1 {
            return false
        }
        
        // L2: Find last j such that self[j] < self[j+1]. Terminate if no such j
        // exists.
        guard let j = indices.reversed().dropFirst()
            .first(where: { self[$0] < self[$0 + 1] })
            else { return false }
        
        // L3: Find last l such that self[j] < self[l], then exchange elements j and l:
        let l = indices.reversed()
            .first(where: { self[j] < self[$0] })!
        swapAt(j, l)
        
        // L4: Reverse elements j+1 ... count-1:
        replaceSubrange(j+1..<count, with: self[j+1..<count].reversed())
        return true
    }
    
    mutating func permuteFunctionalOptimized() -> Bool {
        
        // Nothing to do for empty or single-element arrays:
        if count <= 1 {
            return false
        }
        
        // L2: Find last j such that self[j] <= self[j+1]. Terminate if no such j
        // exists.
        guard let j = indices.reversed().dropFirst()
            .first(where: { self[$0] <= self[$0 + 1] })
            else { return false }
        
        // L3: Find last l such that self[j] <= self[l], then exchange elements j and l:
        let l = indices.reversed()
            .first(where: { self[j] <= self[$0] })!
        swapAt(j, l)
        
        // L4: Reverse elements j+1 ... count-1:
        self[j+1..<count].reverse()
        return true
    }
    
    mutating func permuteFunctionalOptimized2() -> Bool {
        
        // Nothing to do for empty or single-element arrays:
        if count <= 1 {
            return false
        }
        
        // L2: Find last j such that self[j] <= self[j+1]. Terminate if no such j
        // exists.
        guard let j = indices.reversed().dropFirst()
            .first(where: { self[$0] <= self[$0 + 1] })
            else { return false }
        
        // L3: Find last l such that self[j] <= self[l], then exchange elements j and l:
        let l = indices.reversed()
            .first(where: { self[j] <= self[$0] })!
        swapAt(j, l)
        
        // L4: Reverse elements j+1 ... count-1:
        self.reverse(indices: j+1..<count)
        return true
    }
    
    mutating func permuteFunctionalOptimized3() -> Bool {
        
        // Nothing to do for empty or single-element arrays:
        if count <= 1 {
            return false
        }
        
        // L2: Find last j such that self[j] <= self[j+1]. Terminate if no such j
        // exists.
        guard let j = indices.reversed().dropFirst()
            .first(whereMagic: { self[$0] <= self[$0 + 1] })
            else { return false }
        
        // L3: Find last l such that self[j] <= self[l], then exchange elements j and l:
        let l = indices.reversed()
            .first(whereMagic: { self[j] <= self[$0] })!
        swapAt(j, l)
        
        // L4: Reverse elements j+1 ... count-1:
        self.reverse(indices: j+1..<count)
        return true
    }
    
    mutating func permuteFunctionalOptimized4() -> Bool {
        
        // L2: Find last j such that self[j] <= self[j+1]. Terminate if no such j
        // exists.
        guard let j = indices.reversed().dropFirst()
            .first(whereMagic: { self[$0] <= self[$0 + 1] })
            else { return false }
        
        // L3: Find last l such that self[j] <= self[l], then exchange elements j and l:
        let l = indices.reversed()
            .first(whereMagic: { self[j] <= self[$0] })!
        swapAt(j, l)
        
        // L4: Reverse elements j+1 ... count-1:
        self.reverse(indices: Range(uncheckedBounds: (lower: j+1, upper: count)))
        return true
    }
    
    func permutationsOverMutations() -> [[Element]] {
        os_signpost(.begin, log: permutationOSLog, name: SignpostName.permutationsOverMutations)
        var copyOfSelf = self
        let result = Array<[Element]>(repeating: copyOfSelf, count: count.factorial)
        let output = result.map { _ -> [Element] in defer { let _ = copyOfSelf.permute() }; return copyOfSelf }
        os_signpost(.end, log: permutationOSLog, name: SignpostName.permutationsOverMutations)
        return output
    }
    
    func permutationsOverMutationsWithAppendAlloc() -> [[Element]] {
        var copyOfSelf = self
        var result: [[Element]] = [copyOfSelf]
        while copyOfSelf.permute() { result.append(copyOfSelf) }
        return result
    }
    
    func permutationsOverMutationsFunctional() -> [[Element]] {
        var copyOfSelf = self
        let result = Array<[Element]>(repeating: copyOfSelf, count: count.factorial)
        return result.map { _ in defer { let _ = copyOfSelf.permuteFunctional() }; return copyOfSelf }
    }
    
    func permutationsOverMutationsFunctionalWithAppendAlloc() -> [[Element]] {
        var copyOfSelf = self
        var result: [[Element]] = [copyOfSelf]
        while copyOfSelf.permuteFunctional() { result.append(copyOfSelf) }
        return result
    }
    
    func permutationsOverMutationsFunctionalOptimized() -> [[Element]] {
        var copyOfSelf = self
        let result = Array<[Element]>(repeating: copyOfSelf, count: count.factorial)
        return result.map { _ in defer { let _ = copyOfSelf.permuteFunctionalOptimized() }; return copyOfSelf }
    }
    
    func permutationsOverMutationsFunctionalOptimizedWithAppendAlloc() -> [[Element]] {
        var copyOfSelf = self
        var result: [[Element]] = [copyOfSelf]
        while copyOfSelf.permuteFunctionalOptimized() { result.append(copyOfSelf) }
        return result
    }
    
    func permutationsOverMutationsFunctionalOptimized2() -> [[Element]] {
        var copyOfSelf = self
        let result = Array<[Element]>(repeating: copyOfSelf, count: count.factorial)
        return result.map { _ in defer { let _ = copyOfSelf.permuteFunctionalOptimized2() }; return copyOfSelf }
    }
    
    func permutationsOverMutationsFunctionalOptimizedWithAppendAlloc2() -> [[Element]] {
        var copyOfSelf = self
        var result: [[Element]] = [copyOfSelf]
        while copyOfSelf.permuteFunctionalOptimized2() { result.append(copyOfSelf) }
        return result
    }
    
    func permutationsOverMutationsFunctionalOptimized3() -> [[Element]] {
        var copyOfSelf = self
        let result = Array<[Element]>(repeating: copyOfSelf, count: count.factorial)
        return result.map { _ in defer { let _ = copyOfSelf.permuteFunctionalOptimized3() }; return copyOfSelf }
    }
    
    func permutationsOverMutationsFunctionalOptimizedWithAppendAlloc3() -> [[Element]] {
        var copyOfSelf = self
        var result: [[Element]] = [copyOfSelf]
        while copyOfSelf.permuteFunctionalOptimized3() { result.append(copyOfSelf) }
        return result
    }
    
    func permutationsOverMutationsFunctionalOptimized4() -> [[Element]] {
        os_signpost(.begin, log: permutationOSLog, name: SignpostName.permutationsOverMutationsFunctionalOptimized4)
        var copyOfSelf = self
        let result = Array<[Element]>(repeating: copyOfSelf, count: count.factorial)
        let output = result.map { _ -> [Element] in defer { let _ = copyOfSelf.permuteFunctionalOptimized4() }; return copyOfSelf }
        os_signpost(.end, log: permutationOSLog, name: SignpostName.permutationsOverMutationsFunctionalOptimized4)
        return output
    }
    
    func permutationsOverMutationsFunctionalOptimizedWithAppendAlloc4() -> [[Element]] {
        var copyOfSelf = self
        var result: [[Element]] = [copyOfSelf]
        while copyOfSelf.permuteFunctionalOptimized4() { result.append(copyOfSelf) }
        return result
    }
    
    func permutationsConcurrent(concurrentThreads: Int, flatMapAtTheEnd: Bool = false) -> [[Element]] {
        os_signpost(.begin, log: permutationOSLog, name: SignpostName.permutationsConcurrent)
        var result: [[Element]] = []
        let seeds: [[Element]] = (0..<count).map {
            var copyOfSelf = self
            return [copyOfSelf.remove(at: $0)] + copyOfSelf
        }
        var splitSize = count / concurrentThreads
        if count % concurrentThreads > 0 { splitSize += 1 }
        let seedSplits = seeds.split(by: splitSize)
        let group = DispatchGroup()
        var intermediateResults = [[[Element]]].init(repeating: [], count: seedSplits.count)
        seedSplits.enumerated().forEach { index, arrayOfSeeds in
            DispatchQueue.global(qos: .userInteractive).async(group: group) {
                var intermediateResult: [[Element]] = []
                arrayOfSeeds.forEach { (seed) in
                    intermediateResult +=
                        seed.permutationBackgroundWorker(iterationsCount: (self.count - 1).factorial)
                }
                intermediateResults[index] = intermediateResult
            }
        }
        group.wait()
        if flatMapAtTheEnd {
            return intermediateResults.flatMap { $0 }
        }
        intermediateResults.forEach { intermediateResult in
            result += intermediateResult
        }
        os_signpost(.end, log: permutationOSLog, name: SignpostName.permutationsConcurrent)
        return result
    }
    
    private func permutationBackgroundWorker(iterationsCount: Int) -> [[Element]] {
        var copyOfSelf = self
        var result: [[Element]] = [copyOfSelf]
        (1..<iterationsCount).forEach { _ in
            let _ = copyOfSelf.permuteFunctionalOptimized4()
            result.append(copyOfSelf)
        }
        return result
    }
}

