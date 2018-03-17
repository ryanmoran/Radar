import Quick
import Nimble
@testable import Radar

class GroupMenuItemSpec: QuickSpec {
  override func spec() {
    var workspace: FakeWorkspace!
    var item: GroupMenuItem!

    beforeEach {
      let target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      var pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])

      let job = JobFactory.newJob(id: 1, name: "some-job", finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
      let group = GroupFactory.newGroup(name: "some-group", jobs: [job], pipeline: pipeline)
      pipeline.jobs.append(job)

      workspace = FakeWorkspace()
      item = GroupMenuItem(group, workspace: workspace)
    }

    afterEach {
      item = nil
      workspace = nil
    }

    it("has a title") {
      expect(item.title).to(equal("some-group"))
    }

    it("acts as its own target") {
      expect(ObjectIdentifier(item.target!)).to(equal(ObjectIdentifier(item)))
    }

    it("has an action") {
      expect(item.action).to(equal(#selector(item.handleClick(_:))))
    }

    it("has an image") {
      expect(item.image).to(beAnInstanceOf(NSImage.self))
    }

    it("has a job submenu") {
      expect(item.submenu?.numberOfItems).to(equal(1))
      expect(item.submenu?.item(at: 0)?.title).to(equal("some-job"))
    }

    context("when clicked") {
      it("opens the url") {
        item.handleClick(item)
        expect(workspace.openCall.receives.url).to(equal(URL(string:"some-api/teams/some-team/pipelines/some-pipeline?groups=some-group")))
      }
    }
  }
}
