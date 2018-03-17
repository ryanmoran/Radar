import Quick
import Nimble
@testable import Radar

class JobMenuItemSpec: QuickSpec {
  override func spec() {
    var item: JobMenuItem!
    var workspace: FakeWorkspace!

    beforeEach {
      let target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      var pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])

      let job = JobFactory.newJob(id: 1, name: "some-job", finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
      pipeline.jobs.append(job)

      workspace = FakeWorkspace()
      item = JobMenuItem(job, workspace: workspace)
    }

    afterEach {
      item = nil
      workspace = nil
    }

    it("has a title") {
      expect(item.title).to(equal("some-job"))
    }

    it("acts as its own target") {
      expect(ObjectIdentifier(item)).to(equal(ObjectIdentifier(item)))
    }

    it("has an action") {
      expect(item.action).to(equal(#selector(item.handleClick(_:))))
    }

    it("has a tooltip") {
      expect(item.toolTip).to(equal("The state of the some-job job in the some-pipeline pipeline is \"unknown\""))
    }

    it("has an image") {
      expect(item.image).to(beAnInstanceOf(NSImage.self))
    }

    context("when clicked") {
      it("opens the url") {
        item.handleClick(item)
        expect(workspace.openCall.receives.url).to(equal(URL(string:"some-api/teams/some-team/pipelines/some-pipeline/jobs/some-job")))
      }

      context("when the job has a build") {
        it("opens the url that contains a path to the build") {
          let target = TargetFactory.newTarget(api: "some-api", team: "some-team")
          var pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])

          let build = BuildFactory.newBuild(id: 1, name: "some-build", status: "pending")
          let job = JobFactory.newJob(id: 1, name: "some-job", finishedBuild: nil, nextBuild: build, pipeline: pipeline)
          pipeline.jobs.append(job)


          item = JobMenuItem(job, workspace: workspace)

          item.handleClick(item)
          expect(workspace.openCall.receives.url).to(equal(URL(string:"some-api/teams/some-team/pipelines/some-pipeline/jobs/some-job/builds/some-build")))
        }
      }
    }
  }
}
