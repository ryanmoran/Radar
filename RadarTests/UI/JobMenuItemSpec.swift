import Quick
import Nimble
@testable import Radar

class JobMenuItemSpec: QuickSpec {
  override func spec() {
    var item: JobMenuItem!
    var handler: ClickHandler!

    beforeEach {
      let target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      var pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])

      let job = JobFactory.newJob(id: 1, name: "some-job", finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
      pipeline.jobs.append(job)

      let workspace = FakeWorkspace()
      handler = ClickHandler(workspace: workspace)
      item = JobMenuItem(job, handler: handler)
    }

    afterEach {
      item = nil
      handler = nil
    }

    it("has a title") {
      expect(item.title).to(equal("some-job"))
    }

    it("has a target") {
      expect(ObjectIdentifier(item.target!)).to(equal(ObjectIdentifier(handler)))
    }

    it("has an action") {
      expect(item.action).to(equal(#selector(handler.handle(_:))))
    }

    it("has a tooltip") {
      expect(item.toolTip).to(equal("The state of the some-job job in the some-pipeline pipeline is \"unknown\""))
    }

    it("has an image") {
      expect(item.image).to(beAnInstanceOf(NSImage.self))
    }

    it("has a representedObject that contains a url for the job") {
      let url = item.representedObject as! URL
      expect(url.absoluteString).to(equal("some-api/teams/some-team/pipelines/some-pipeline/jobs/some-job"))
    }

    context("when the job has a build") {
      it("has a representedObject that contains a url for the build") {
        let target = TargetFactory.newTarget(api: "some-api", team: "some-team")
        var pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])

        let build = BuildFactory.newBuild(id: 1, name: "some-build", status: "pending")
        let job = JobFactory.newJob(id: 1, name: "some-job", finishedBuild: nil, nextBuild: build, pipeline: pipeline)
        pipeline.jobs.append(job)


        item = JobMenuItem(job, handler: handler)

        let url = item.representedObject as! URL
        expect(url.absoluteString).to(equal("some-api/teams/some-team/pipelines/some-pipeline/jobs/some-job/builds/some-build"))
      }
    }
  }
}
