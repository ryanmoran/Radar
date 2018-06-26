import Quick
import Nimble
import Concourse

class JobSpec: QuickSpec {
  override func spec() {
    var target: Target!
    var pipeline: Pipeline!
    var job: Job!

    beforeEach {
      target = TargetFactory.newTarget(api: "some-api", team: "some-team")
      pipeline = PipelineFactory.newPipeline(id: 1, name: "some-pipeline", target: target, groups: [])
      job = JobFactory.newJob(id: 1, name: "some-job", paused: false, teamName: "some-team", pipelineName: "some-pipeline", finishedBuild: nil, nextBuild: nil, pipeline: pipeline)
    }

    afterEach {
      job = nil
    }

    it("has an id") {
      expect(job.id).to(equal(1))
    }

    it("has a name") {
      expect(job.name).to(equal("some-job"))
    }

    it("has a teamName") {
      expect(job.teamName).to(equal("some-team"))
    }

    it("has a pipelineName") {
      expect(job.pipelineName).to(equal("some-pipeline"))
    }

    describe("status/transientStatus") {
      var nextBuild: Build!
      var finishedBuild: Build!

      beforeEach {
        nextBuild = BuildFactory.newBuild(id: 1, name: "next-build", status: "next-status")
        finishedBuild = BuildFactory.newBuild(id: 1, name: "finished-build", status: "finished-status")
      }

      context("when there are no known builds") {
        it("has a status") {
          expect(job.status).to(equal("unknown"))
        }

        it("has a transientStatus") {
          expect(job.transientStatus).to(equal("unknown"))
        }
      }

      context("when there is a next, and finished build") {
        beforeEach {
          job = JobFactory.newJob(id: 1, name: "some-job", paused: false, teamName: "some-team", pipelineName: "some-pipeline", finishedBuild: finishedBuild, nextBuild: nextBuild, pipeline: pipeline)
        }

        it("uses the status of the finished build as the status") {
          expect(job.status).to(equal("finished-status"))
        }

        it("uses the status of the next build as the transientStatus") {
          expect(job.transientStatus).to(equal("next-status"))
        }
      }

      context("when there is no next build, but there is a finished build") {
        beforeEach {
          job = JobFactory.newJob(id: 1, name: "some-job", paused: false, teamName: "some-team", pipelineName: "some-pipeline", finishedBuild: finishedBuild, nextBuild: nil, pipeline: pipeline)
        }

        it("uses the status of the finished build as the status") {
          expect(job.status).to(equal("finished-status"))
        }

        it("uses the status of the finished build as the transientStatus") {
          expect(job.transientStatus).to(equal("finished-status"))
        }
      }

      context("when the job is paused") {
        beforeEach {
          job = JobFactory.newJob(id: 1, name: "some-job", paused: true, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: finishedBuild, nextBuild: nextBuild, pipeline: pipeline)
        }

        it("reports the status as paused") {
          expect(job.status).to(equal("paused"))
        }

        it("uses the status of the next build as the transientStatus") {
          expect(job.transientStatus).to(equal("next-status"))
        }

        context("when there is no next build") {
          beforeEach {
            job = JobFactory.newJob(id: 1, name: "some-job", paused: true, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: finishedBuild, nextBuild: nil, pipeline: pipeline)
          }

          it("reports the status as paused") {
            expect(job.status).to(equal("paused"))
          }

          it("uses the status of the next build as the transientStatus") {
            expect(job.transientStatus).to(equal("paused"))
          }
        }
      }
    }

    describe("build") {
      context("when there are no known builds") {
        it("returns nil") {
          expect(job.build).to(beNil())
        }
      }

      context("when there is a finished build") {
        it("returns the finished build") {
          let build = BuildFactory.newBuild(id: 1, name: "some-finished-build", status: "some-finished-status")
          job = JobFactory.newJob(id: 1, name: "some-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: build, nextBuild: nil, pipeline: pipeline)

          expect(job.build?.name).to(equal("some-finished-build"))
        }
      }

      context("when there is a next build") {
        it("returns the next build") {
          let build = BuildFactory.newBuild(id: 1, name: "some-next-build", status: "some-next-status")
          job = JobFactory.newJob(id: 1, name: "some-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: nil, nextBuild: build, pipeline: pipeline)

          expect(job.build?.name).to(equal("some-next-build"))
        }
      }
    }

    it("belongs to a pipeline") {
      expect(job.pipeline).to(equal(pipeline))
    }

    it("belongs to a target") {
      expect(job.target).to(equal(target))
    }

    describe("Equatable") {
      it("can be equated") {
        let build = BuildFactory.newBuild(id: 1, name: "some-build", status: "some-status")

        let firstJob = JobFactory.newJob(id: 1, name: "some-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: build, nextBuild: nil, pipeline: pipeline)
        let secondJob = JobFactory.newJob(id: 1, name: "some-job", paused: false, teamName: "some-team", pipelineName: pipeline.name, finishedBuild: build, nextBuild: nil, pipeline: pipeline)

        expect(firstJob).to(equal(secondJob))
      }
    }
  }
}
