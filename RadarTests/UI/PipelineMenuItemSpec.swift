import Quick
import Nimble
import Concourse
@testable import Radar

class PipelineMenuItemSpec: QuickSpec {
  override func spec() {
    var handler: ClickHandler!
    var item: PipelineMenuItem!

    beforeEach {
      var target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      var pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])
      target.pipelines.append(pipeline)

      let job = JobFactory.newJob(id: 1, name: "some-job", finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
      pipeline.jobs.append(job)

      handler = ClickHandler(workspace: FakeWorkspace())
      item = PipelineMenuItem(pipeline, handler: handler)
    }

    afterEach {
      item = nil
      handler = nil
    }

    it("has a title") {
      expect(item.title).to(equal("some-pipeline"))
    }

    it("has a target") {
      expect(ObjectIdentifier(item.target!)).to(equal(ObjectIdentifier(handler)))
    }

    it("has an action") {
      expect(item.action).to(equal(#selector(handler.handle(_:))))
    }

    it("has an image") {
      expect(item.image).to(beAnInstanceOf(NSImage.self))
    }

    it("has a representedObject containing a URL for the pipeline") {
      let url = item.representedObject as! URL
      expect(url.absoluteString).to(equal("some-api/teams/some-team/pipelines/some-pipeline"))
    }

    it("has a submenu containing jobs") {
      expect(item.submenu?.numberOfItems).to(equal(1))
      expect(item.submenu?.item(at: 0)?.title).to(equal("some-job"))
    }

    context("when the pipeline contains groups") {
      beforeEach {
        let group1 = GroupFactory.newAPIGroup(name: "some-group", jobs: [])
        let group2 = GroupFactory.newAPIGroup(name: "other-group", jobs: [])

        let target = TargetFactory.newTarget(api: "some-api", team: "some-team")
        let apiPipeline = PipelineFactory.newAPIPipeline(id: 1, name: "some-pipeline", groups: [group1, group2])
        let pipeline = Concourse.Pipeline(apiPipeline, target: target)

        item = PipelineMenuItem(pipeline, handler: handler)
      }
      it("has a representedObject containing a URL for the pipeline") {
        let url = item.representedObject as! URL
        expect(url.absoluteString).to(equal("some-api/teams/some-team/pipelines/some-pipeline?groups=some-group&groups=other-group"))
      }

      it("has a submenu containing jobs") {
        expect(item.submenu?.numberOfItems).to(equal(2))
        expect(item.submenu?.item(at: 0)?.title).to(equal("some-group"))
        expect(item.submenu?.item(at: 1)?.title).to(equal("other-group"))
      }
    }
  }
}
