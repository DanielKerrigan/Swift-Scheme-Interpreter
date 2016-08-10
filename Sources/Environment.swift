import Foundation

class Environment {

    var parent: Environment?
    var current = [String:Node]()

    init(keys: [String], values: [Node], parent: Environment?) {
        self.parent = parent
        for (key, value) in zip(keys, values) {
            self.current[key] = value
        }
    }

    init(current: [String:Node] , parent: Environment?) {
        self.parent = parent
        self.current = current
    }

    subscript(index: String) -> Node? {
        get {
            return current[index]
        }
        set {
            current[index] = newValue
        }
    }

    func find(key: String) -> Environment? {
        if current[key] != nil {
            return self
        } 
        if let parent = parent {
            return parent.find(key: key)
        }
        return nil
    }
}

