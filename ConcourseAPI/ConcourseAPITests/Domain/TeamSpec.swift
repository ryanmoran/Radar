import Quick
import Nimble
import ConcourseAPI

class TeamSpec: QuickSpec {
  override func spec() {
    describe("JSON decoding") {
      it("can be decoded from JSON") {
        let json = """
          {
            "id": 1,
            "name": "some-name"
          }
        """

        var team: ConcourseAPI.Team!
        expect {
          team = try JSONDecoder().decode(ConcourseAPI.Team.self, from: json.data(using: .utf8)!)
        }.notTo(raiseException())

        expect(team.id).to(equal(1))
        expect(team.name).to(equal("some-name"))
      }
    }
  }
}
