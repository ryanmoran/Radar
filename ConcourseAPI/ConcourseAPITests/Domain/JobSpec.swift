import Quick
import Nimble
import ConcourseAPI

class JobSpec: QuickSpec {
  override func spec() {
    describe("JSON decoding") {
      it("can be decoded from JSON") {
        let json = """
          {
            "id": 1,
            "name": "some-name",
            "paused": false,
            "team_name": "some-team",
            "pipeline_name": "some-pipeline",
            "next_build": {
              "id": 2,
              "name": "next-build-name",
              "status": "started"
            },
            "finished_build": {
              "id": 1,
              "name": "finished-build-name",
              "status": "succeeded"
            },
            "transition_build": {
              "id": 3,
              "name": "transition-build-name",
              "status": "pending"
            }
          }
        """

        var job: ConcourseAPI.Job!

        expect {
          job = try JSONDecoder().decode(ConcourseAPI.Job.self, from: json.data(using: .utf8)!)
        }.notTo(raiseException())

        expect(job.id).to(equal(1))
        expect(job.name).to(equal("some-name"))
        expect(job.paused).to(equal(false))
        expect(job.teamName).to(equal("some-team"))
        expect(job.pipelineName).to(equal("some-pipeline"))

        expect(job.nextBuild?.id).to(equal(2))
        expect(job.nextBuild?.name).to(equal("next-build-name"))
        expect(job.nextBuild?.status).to(equal("started"))

        expect(job.finishedBuild?.id).to(equal(1))
        expect(job.finishedBuild?.name).to(equal("finished-build-name"))
        expect(job.finishedBuild?.status).to(equal("succeeded"))

        expect(job.transitionBuild?.id).to(equal(3))
        expect(job.transitionBuild?.name).to(equal("transition-build-name"))
        expect(job.transitionBuild?.status).to(equal("pending"))
      }
    }
  }
}
