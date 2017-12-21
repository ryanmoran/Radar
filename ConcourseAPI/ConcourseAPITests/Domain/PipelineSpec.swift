import Quick
import Nimble
import ConcourseAPI

class PipelineSpec: QuickSpec {
  override func spec() {
    describe("JSON decoding") {
      it("can be decoded from JSON") {
        let json = """
          {
            "id": 1,
            "name": "some-name",
            "groups": [
              {
                "name": "some-group",
                "jobs": [
                  "some-job",
                  "other-job"
                ]
              },
              {
                "name": "other-group",
                "jobs": [
                  "some-other-job",
                  "another-other-job"
                ]
              }
            ]
          }
        """

        var pipeline: ConcourseAPI.Pipeline!
        expect {
          pipeline = try JSONDecoder().decode(ConcourseAPI.Pipeline.self, from: json.data(using: .utf8)!)
        }.notTo(raiseException())

        expect(pipeline.id).to(equal(1))
        expect(pipeline.name).to(equal("some-name"))

        expect(pipeline.groups).to(haveCount(2))
        expect(pipeline.groups).to(containElementSatisfying({ group in
          return group.name == "some-group" && group.jobs == ["some-job", "other-job"]
        }))
        expect(pipeline.groups).to(containElementSatisfying({ group in
          return group.name == "other-group" && group.jobs == ["some-other-job", "another-other-job"]
        }))
      }

    }
  }
}
