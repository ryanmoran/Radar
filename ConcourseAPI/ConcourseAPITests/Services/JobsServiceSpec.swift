import Quick
import Nimble
import ConcourseAPI

class JobsServiceSpec: QuickSpec {
  override func spec() {
    var target: FakeTarget!
    var jobsService: JobsService!

    beforeEach {
      target = FakeTarget()
      jobsService = JobsService()
    }

    afterEach {
      jobsService = nil
      target = nil
    }

    describe("list") {
      it("returns a list of jobs") {
        let json = """
          [
            {
              "id": 1,
              "name": "some-name",
              "paused": false,
              "next_build": null,
              "finished_build": null,
              "transition_build": null
            },
            {
              "id": 2,
              "name": "other-name",
              "paused": false,
              "next_build": null,
              "finished_build": null,
              "transition_build": null
            }
          ]
        """

        target.getCall.returns.response = HTTPResponse(statusCode: 200, body: json.data(using: .utf8)!)

        let (jobs, error) = jobsService.list(target: target, pipelineName: "some-pipeline-name")
        expect(error).to(beNil())

        expect(jobs).to(haveCount(2))
        expect(jobs).to(containElementSatisfying({ job in
          return job.id == 1 && job.name == "some-name"
        }))
        expect(jobs).to(containElementSatisfying({ job in
          return job.id == 2 && job.name == "other-name"
        }))

        expect(target.getCall.receives.path).to(equal("/pipelines/some-pipeline-name/jobs"))
      }

      describe("failure cases") {
        context("when the target returns an error") {
          it("returns an error") {
            target.getCall.returns.error = TargetError("failed to list jobs")

            let (_, error) = jobsService.list(target: target, pipelineName: "some-pipeline-name")
            expect((error as! TargetError).reason).to(equal("failed to list jobs"))
          }
        }

        context("when the response contains malformed JSON") {
          it("returns an error") {
            target.getCall.returns.response = HTTPResponse(statusCode: 200, body: "%%%".data(using: .utf8)!)

            let (_, error) = jobsService.list(target: target, pipelineName: "some-pipeline-name")
            expect(error?.localizedDescription).to(equal("The data couldn’t be read because it isn’t in the correct format."))
          }
        }
      }
    }
  }
}
