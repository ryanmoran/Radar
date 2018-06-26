import Quick
import Nimble
import Concourse
@testable import Radar

class PipelineMenuItemSpec: QuickSpec {
  override func spec() {
    var workspace: FakeWorkspace!
    var item: PipelineMenuItem!

    beforeEach {
      var target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      var pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])
      target.pipelines.append(pipeline)

      let job = JobFactory.newJob(id: 1, name: "some-job", teamName: target.team, pipelineName: pipeline.name, finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
      pipeline.jobs.append(job)

      workspace = FakeWorkspace()
      item = PipelineMenuItem(pipeline, workspace: workspace)
    }

    afterEach {
      item = nil
      workspace = nil
    }

    it("has a title") {
      expect(item.title).to(equal("some-pipeline"))
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

    it("has a submenu containing jobs") {
      expect(item.submenu?.numberOfItems).to(equal(1))
      expect(item.submenu?.item(at: 0)?.title).to(equal("some-job"))
    }

    context("when clicked") {
      it("opens the url") {
        item.handleClick(item)
        expect(workspace.openCall.receives.url).to(equal(URL(string:"some-api/teams/some-team/pipelines/some-pipeline")))
      }
    }

    context("when the pipeline contains groups") {
      beforeEach {
        let group1 = GroupFactory.newAPIGroup(name: "some-group", jobs: [])
        let group2 = GroupFactory.newAPIGroup(name: "other-group", jobs: [])

        let target = TargetFactory.newTarget(api: "some-api", team: "some-team")
        let apiPipeline = PipelineFactory.newAPIPipeline(id: 1, name: "some-pipeline", groups: [group1, group2])
        let pipeline = Concourse.Pipeline(apiPipeline, target: target)

        item = PipelineMenuItem(pipeline, workspace: workspace)
      }

      it("has a submenu containing jobs") {
        expect(item.submenu?.numberOfItems).to(equal(2))
        expect(item.submenu?.item(at: 0)?.title).to(equal("some-group"))
        expect(item.submenu?.item(at: 1)?.title).to(equal("other-group"))
      }

      context("when clicked") {
        it("opens the url that includes all groups") {
          item.handleClick(item)
          expect(workspace.openCall.receives.url).to(equal(URL(string:"some-api/teams/some-team/pipelines/some-pipeline?groups=some-group&groups=other-group")))
        }
      }
    }
  }
}
