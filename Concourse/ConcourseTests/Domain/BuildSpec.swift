import Quick
import Nimble
import Concourse

class BuildSpec: QuickSpec {
  override func spec() {
    var build: Build!

    beforeEach {
      build = BuildFactory.newBuild(id: 1, name: "some-build", status: "some-status")
    }

    afterEach {
      build = nil
    }

    it("has an id") {
      expect(build.id).to(equal(1))
    }

    it("has a name") {
      expect(build.name).to(equal("some-build"))
    }

    it("has a status") {
      expect(build.status).to(equal("some-status"))
    }

    describe("Equatable") {
      it("can be equated") {
        let otherBuild = BuildFactory.newBuild(id: 1, name: "some-build", status: "some-status")

        expect(build).to(equal(otherBuild))
      }
    }
  }
}
