import Quick
import Nimble
import Concourse

class GroupSpec: QuickSpec {
  override func spec() {
    var target: Target!
    var pipeline: Pipeline!
    var group: Group!

    beforeEach {
      target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])
      group = GroupFactory.newGroup(name: "some-group", jobs: [
        JobFactory.newJob(id: 1, name: "some-job", paused: false, teamName: "some-team", pipelineName: "some-pipeline", finishedBuild: nil, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 1, name: "other-job", paused: false, teamName: "some-team", pipelineName: "some-pipeline", finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
        ], pipeline: pipeline)
    }

    afterEach {
      group = nil
      pipeline = nil
      target = nil
    }

    it("has a name") {
      expect(group.name).to(equal("some-group"))
    }

    it("has a status/transientStatus") {
      expect(group.status).to(equal("unknown"))

      let succeededBuild = BuildFactory.newBuild(id: 1, name: "succeeded-build", status: "succeeded")
      let abortedBuild = BuildFactory.newBuild(id: 1, name: "aborted-build", status: "aborted")
      let erroredBuild = BuildFactory.newBuild(id: 1, name: "errored-build", status: "errored")
      let pendingBuild = BuildFactory.newBuild(id: 1, name: "pending-build", status: "pending")
      let failedBuild = BuildFactory.newBuild(id: 1, name: "failed-build", status: "failed")
      let startedBuild = BuildFactory.newBuild(id: 1, name: "started-build", status: "started")

      var jobs = [
        JobFactory.newJob(id: 1, name: "first-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: succeededBuild, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 2, name: "second-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: abortedBuild, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 3, name: "third-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: erroredBuild, nextBuild: pendingBuild, pipeline: pipeline),
        JobFactory.newJob(id: 4, name: "fourth-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: pendingBuild, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 5, name: "fifth-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: failedBuild, nextBuild: startedBuild, pipeline: pipeline),
        JobFactory.newJob(id: 6, name: "sixth-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: startedBuild, nextBuild: nil, pipeline: pipeline),
        JobFactory.newJob(id: 7, name: "seventh-job", paused: true, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: nil, nextBuild: nil, pipeline: pipeline),
      ]

      group = GroupFactory.newGroup(name: "some-group", jobs: jobs, pipeline: pipeline)
      expect(group.status).to(equal("paused"))
      expect(group.transientStatus).to(equal("started"))

      jobs.removeLast()
      group = GroupFactory.newGroup(name: "some-group", jobs: jobs, pipeline: pipeline)
      expect(group.status).to(equal("started"))
      expect(group.transientStatus).to(equal("started"))

      jobs.removeLast()
      group = GroupFactory.newGroup(name: "some-group", jobs: jobs, pipeline: pipeline)
      expect(group.status).to(equal("failed"))
      expect(group.transientStatus).to(equal("started"))

      jobs.removeLast()
      group = GroupFactory.newGroup(name: "some-group", jobs: jobs, pipeline: pipeline)
      expect(group.status).to(equal("pending"))
      expect(group.transientStatus).to(equal("pending"))

      jobs.removeLast()
      group = GroupFactory.newGroup(name: "some-group", jobs: jobs, pipeline: pipeline)
      expect(group.status).to(equal("errored"))
      expect(group.transientStatus).to(equal("pending"))

      jobs.removeLast()
      group = GroupFactory.newGroup(name: "some-group", jobs: jobs, pipeline: pipeline)
      expect(group.status).to(equal("aborted"))
      expect(group.transientStatus).to(equal("aborted"))

      jobs.removeLast()
      group = GroupFactory.newGroup(name: "some-group", jobs: jobs, pipeline: pipeline)
      expect(group.status).to(equal("succeeded"))
      expect(group.transientStatus).to(equal("succeeded"))

      jobs.removeLast()
      group = GroupFactory.newGroup(name: "some-group", jobs: jobs, pipeline: pipeline)
      expect(group.status).to(equal("unknown"))
      expect(group.transientStatus).to(equal("unknown"))
    }

    it("belongs to a pipeline") {
      expect(group.pipeline).to(equal(pipeline))
    }

    it("belongs to a target") {
      expect(group.target).to(equal(target))
    }

    describe("Equatable") {
      it("can be equated") {
        let job1 = JobFactory.newJob(id: 1, name: "some-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
        let job2 = JobFactory.newJob(id: 1, name: "other-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
        let otherGroup = GroupFactory.newGroup(name: "some-group", jobs: [job1, job2], pipeline: pipeline)

        expect(group).to(equal(otherGroup))
      }
    }
  }
}
