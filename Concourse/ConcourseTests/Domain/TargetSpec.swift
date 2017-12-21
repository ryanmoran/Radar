import Quick
import Nimble
import Concourse
import ConcourseAPI

class TargetSpec: QuickSpec {
  override func spec() {
    var pipeline1: Concourse.Pipeline!
    var pipeline2: Concourse.Pipeline!
    var target: Concourse.Target!

    beforeEach {
      target = TargetFactory.newTarget(api: "some-api", team: "some-team")

      pipeline1 = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])
      target.pipelines.append(pipeline1)

      pipeline2 = PipelineFactory.newPipeline(id: 2, name: "other-pipeline", target: target, groups: [])
      target.pipelines.append(pipeline2)
    }

    afterEach {
      target = nil
      pipeline1 = nil
      pipeline2 = nil
    }

    it("has an api") {
      expect(target.api).to(equal("some-api"))
    }

    it("has a team") {
      expect(target.team).to(equal("some-team"))
    }

    it("has pipelines") {
      expect(target.pipelines).to(haveCount(2))
      expect(target.pipelines).to(containElementSatisfying({ pipeline in
        return pipeline.name == "some-pipeline"
      }))
      expect(target.pipelines).to(containElementSatisfying({ pipeline in
        return pipeline.name == "other-pipeline"
      }))
    }

    describe("Equatable") {
      it("can be equated") {
        var otherTarget = TargetFactory.newTarget(api: "some-api", team: "some-team")
        otherTarget.pipelines.append(pipeline1)
        otherTarget.pipelines.append(pipeline2)

        expect(target).to(equal(otherTarget))
      }
    }
  }
}
