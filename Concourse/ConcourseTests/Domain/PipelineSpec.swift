import Quick
import Nimble
import Concourse

class PipelineSpec: QuickSpec {
  override func spec() {
    var target: Target!
    var pipeline: Pipeline!

    beforeEach {
      let group1 = GroupFactory.newAPIGroup(name: "some-group", jobs: [])
      let group2 = GroupFactory.newAPIGroup(name: "other-group", jobs: [])

      target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      let apiPipeline = PipelineFactory.newAPIPipeline(id: 1, name: "some-pipeline", groups: [group1, group2])
      pipeline = Pipeline(apiPipeline, target: target)

      let succeededBuild = BuildFactory.newBuild(id: 1, name: "succeeded-build", status: "succeeded")
      let abortedBuild = BuildFactory.newBuild(id: 1, name: "aborted-build", status: "aborted")
      let erroredBuild = BuildFactory.newBuild(id: 1, name: "errored-build", status: "errored")
      let pendingBuild = BuildFactory.newBuild(id: 1, name: "pending-build", status: "pending")
      let failedBuild = BuildFactory.newBuild(id: 1, name: "failed-build", status: "failed")
      let startedBuild = BuildFactory.newBuild(id: 1, name: "started-build", status: "started")

      for job in [
        JobFactory.newJob(id: 1, name: "succeeded-job", paused: false, finishedBuild: succeededBuild, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 2, name: "aborted-job", paused: false, finishedBuild: abortedBuild, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 3, name: "errored-job", paused: false, finishedBuild: erroredBuild, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 4, name: "pending-job", paused: false, finishedBuild: pendingBuild, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 5, name: "failed-job", paused: false, finishedBuild: failedBuild, nextBuild: pendingBuild, pipeline: pipeline),
        JobFactory.newJob(id: 6, name: "started-job", paused: false, finishedBuild: startedBuild, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 7, name: "paused-job", paused: true, finishedBuild: nil, nextBuild: startedBuild, pipeline: pipeline),
        ] {
          pipeline.jobs.append(job)
      }
    }

    afterEach {
      pipeline = nil
      target = nil
    }

    it("has an id") {
      expect(pipeline.id).to(equal(1))
    }

    it("has a name") {
      expect(pipeline.name).to(equal("some-pipeline"))
    }

    it("has a status") {
      expect(pipeline.status).to(equal("paused"))
      expect(pipeline.transientStatus).to(equal("started"))

      pipeline.jobs.removeLast()
      expect(pipeline.status).to(equal("started"))
      expect(pipeline.transientStatus).to(equal("started"))

      pipeline.jobs.removeLast()
      expect(pipeline.status).to(equal("failed"))
      expect(pipeline.transientStatus).to(equal("pending"))

      pipeline.jobs.removeLast()
      expect(pipeline.status).to(equal("pending"))
      expect(pipeline.status).to(equal("pending"))

      pipeline.jobs.removeLast()
      expect(pipeline.status).to(equal("errored"))
      expect(pipeline.status).to(equal("errored"))

      pipeline.jobs.removeLast()
      expect(pipeline.status).to(equal("aborted"))
      expect(pipeline.status).to(equal("aborted"))

      pipeline.jobs.removeLast()
      expect(pipeline.status).to(equal("succeeded"))
      expect(pipeline.status).to(equal("succeeded"))

      pipeline.jobs.removeLast()
      expect(pipeline.status).to(equal("unknown"))
      expect(pipeline.status).to(equal("unknown"))
    }

    it("has groups") {
      expect(pipeline.groups).to(haveCount(2))
      expect(pipeline.groups).to(containElementSatisfying({ group in
        return group.name == "some-group"
      }))
      expect(pipeline.groups).to(containElementSatisfying({ group in
        return group.name == "other-group"
      }))
    }

    it("has jobs") {
      expect(pipeline.jobs).to(haveCount(7))
      expect(pipeline.jobs).to(containElementSatisfying({ job in return job.name == "succeeded-job" }))
      expect(pipeline.jobs).to(containElementSatisfying({ job in return job.name == "aborted-job" }))
      expect(pipeline.jobs).to(containElementSatisfying({ job in return job.name == "errored-job" }))
      expect(pipeline.jobs).to(containElementSatisfying({ job in return job.name == "pending-job" }))
      expect(pipeline.jobs).to(containElementSatisfying({ job in return job.name == "failed-job" }))
      expect(pipeline.jobs).to(containElementSatisfying({ job in return job.name == "started-job" }))
      expect(pipeline.jobs).to(containElementSatisfying({ job in return job.name == "paused-job" }))
    }

    it("belongs to a target") {
      expect(pipeline.target).to(equal(target))
    }

    describe("Equatable") {
      it("can be equated") {
        let group1 = GroupFactory.newAPIGroup(name: "some-group", jobs: [])
        let group2 = GroupFactory.newAPIGroup(name: "other-group", jobs: [])

        let apiPipeline = PipelineFactory.newAPIPipeline(id: 1, name: "some-pipeline", groups: [group1, group2])
        var otherPipeline = Pipeline(apiPipeline, target: target)

        let succeededBuild = BuildFactory.newBuild(id: 1, name: "succeeded-build", status: "succeeded")
        let abortedBuild = BuildFactory.newBuild(id: 1, name: "aborted-build", status: "aborted")
        let erroredBuild = BuildFactory.newBuild(id: 1, name: "errored-build", status: "errored")
        let pendingBuild = BuildFactory.newBuild(id: 1, name: "pending-build", status: "pending")
        let failedBuild = BuildFactory.newBuild(id: 1, name: "failed-build", status: "failed")
        let startedBuild = BuildFactory.newBuild(id: 1, name: "started-build", status: "started")

        for job in [
          JobFactory.newJob(id: 1, name: "succeeded-job", paused: false, finishedBuild: succeededBuild, nextBuild: nil, pipeline: otherPipeline),
          JobFactory.newJob(id: 2, name: "aborted-job", paused: false, finishedBuild: abortedBuild, nextBuild: nil, pipeline: otherPipeline),
          JobFactory.newJob(id: 3, name: "errored-job", paused: false, finishedBuild: erroredBuild, nextBuild: nil, pipeline: otherPipeline),
          JobFactory.newJob(id: 4, name: "pending-job", paused: false, finishedBuild: pendingBuild, nextBuild: nil, pipeline: otherPipeline),
          JobFactory.newJob(id: 5, name: "failed-job", paused: false, finishedBuild: failedBuild, nextBuild: pendingBuild, pipeline: otherPipeline),
          JobFactory.newJob(id: 6, name: "started-job", paused: false, finishedBuild: startedBuild, nextBuild: nil, pipeline: otherPipeline),
          JobFactory.newJob(id: 7, name: "paused-job", paused: true, finishedBuild: nil, nextBuild: startedBuild, pipeline: otherPipeline),
          ] {
            otherPipeline.jobs.append(job)
        }

        expect(pipeline).to(equal(otherPipeline))
      }
    }
  }
}
