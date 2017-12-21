import Quick
import Nimble
@testable import Radar

class GroupMenuItemSpec: QuickSpec {
  override func spec() {
    var handler: ClickHandler!
    var item: GroupMenuItem!

    beforeEach {
      let target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      var pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])

      let job = JobFactory.newJob(id: 1, name: "some-job", finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
      let group = GroupFactory.newGroup(name: "some-group", jobs: [job], pipeline: pipeline)
      pipeline.jobs.append(job)

      handler = ClickHandler(workspace: FakeWorkspace())
      item = GroupMenuItem(group, handler: handler)
    }

    afterEach {
      item = nil
      handler = nil
    }

    it("has a title") {
      expect(item.title).to(equal("some-group"))
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

    it("has a representedObject containing a URL for the group") {
      let url = item.representedObject as! URL
      expect(url.absoluteString).to(equal("some-api/teams/some-team/pipelines/some-pipeline?groups=some-group"))
    }

    it("has a job submenu") {
      expect(item.submenu?.numberOfItems).to(equal(1))
      expect(item.submenu?.item(at: 0)?.title).to(equal("some-job"))
    }
  }
}
