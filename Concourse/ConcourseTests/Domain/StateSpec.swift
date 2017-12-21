import Quick
import Nimble
import Concourse

class StateSpec: QuickSpec {
  override func spec() {
    var state: State!

    beforeEach {
      state = State()
      state.targets.append(TargetFactory.newTarget(api: "first-api", team: "first-team"))
      state.targets.append(TargetFactory.newTarget(api: "second-api", team: "second-team"))
    }

    afterEach {
      state = nil
    }

    it("has targets") {
      expect(state.targets).to(haveCount(2))
      expect(state.targets).to(containElementSatisfying({ target in
        return target.api == "first-api" && target.team == "first-team"
      }))
      expect(state.targets).to(containElementSatisfying({ target in
        return target.api == "second-api" && target.team == "second-team"
      }))
    }

    describe("Equatable") {
      it("can be equated") {
        var otherState = State()
        otherState.targets.append(TargetFactory.newTarget(api: "first-api", team: "first-team"))
        otherState.targets.append(TargetFactory.newTarget(api: "second-api", team: "second-team"))

        expect(state).to(equal(otherState))
      }
    }
  }
}
