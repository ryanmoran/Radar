import Quick
import Nimble
import Concourse

enum TestableErrors: Error {
  case String(String)
}

extension TestableErrors: Equatable {
  static func == (lhs: TestableErrors, rhs: TestableErrors) -> Bool {
    switch (lhs, rhs) {
    case (.String(let l), .String(let r)):
      print(l, r)
      return l == r
    }
  }
}

class StateManagerSpec: QuickSpec {
  override func spec() {
    var manager: StateManager!
    var pipelinesService: FakePipelineListable!
    var jobsService: FakeJobListable!
    var targets: [Target] = []
    var firstDelegate: FakeStateManagerDelegate!
    var secondDelegate: FakeStateManagerDelegate!
    var logger: FakeLoggable!

    beforeEach {
      pipelinesService = FakePipelineListable()
      jobsService = FakeJobListable()
      firstDelegate = FakeStateManagerDelegate()
      secondDelegate = FakeStateManagerDelegate()
      logger = FakeLoggable()

      let firstTarget = TargetFactory.newTarget(api: "first-api", team: "first-team")

      let firstBuild = BuildFactory.newBuild(id: 1, name: "first-build", status: "succeeded")
      let firstJob = JobFactory.newAPIJob(id: 1, name: "first-job", paused: false, teamName: "first-team", pipelineName: "first-pipeline", finishedBuild: firstBuild, nextBuild: nil)
      let firstGroup = GroupFactory.newAPIGroup(name: "first-group", jobs: [firstJob.name])
      let firstPipeline = PipelineFactory.newAPIPipeline(id: 1, name: "first-pipeline", groups: [firstGroup])

      let secondBuild = BuildFactory.newBuild(id: 2, name: "second-build", status: "failed")
      let secondJob = JobFactory.newAPIJob(id: 2, name: "second-job", paused: false, teamName: "first-team", pipelineName: "second-pipeline", finishedBuild: nil, nextBuild: secondBuild)
      let secondGroup = GroupFactory.newAPIGroup(name: "second-group", jobs: [secondJob.name])
      let secondPipeline = PipelineFactory.newAPIPipeline(id: 2, name: "second-pipeline", groups: [secondGroup])

      let thirdBuild = BuildFactory.newBuild(id: 3, name: "third-build", status: "pending")
      let thirdJob = JobFactory.newAPIJob(id: 3, name: "third-job", paused: false, teamName: "first-team", pipelineName: "third-pipeline", finishedBuild: thirdBuild, nextBuild: nil)
      let thirdGroup = GroupFactory.newAPIGroup(name: "third-group", jobs: [thirdJob.name])
      let thirdPipeline = PipelineFactory.newAPIPipeline(id: 3, name: "third-pipeline", groups: [thirdGroup])

      let fourthBuild = BuildFactory.newBuild(id: 4, name: "fourth-build", status: "errored")
      let fourthJob = JobFactory.newAPIJob(id: 4, name: "fourth-job", paused: false, teamName: "first-team", pipelineName: "fourth-pipeline", finishedBuild: fourthBuild, nextBuild: nil)
      let fourthGroup = GroupFactory.newAPIGroup(name: "fourth-group", jobs: [fourthJob.name])
      let fourthPipeline = PipelineFactory.newAPIPipeline(id: 4, name: "fourth-pipeline", groups: [fourthGroup])


      pipelinesService.listCall.returns.pipelines = [firstPipeline, secondPipeline, thirdPipeline, fourthPipeline]
      jobsService.listCall.returns.jobs = [firstJob, secondJob, thirdJob, fourthJob]
      targets.append(firstTarget)

      manager = StateManager(logger: logger, targets: targets, pipelinesService: pipelinesService, jobsService: jobsService)
      manager.delegates.append(firstDelegate)
      manager.delegates.append(secondDelegate)
    }

    afterEach {
      manager = nil
      pipelinesService = nil
      jobsService = nil
      targets = []
    }

    describe("fetch") {
      var state: State!

      beforeEach {
        let (fetchedState, error) = manager.fetch()
        expect(error).to(beNil())

        state = fetchedState
      }

      afterEach {
        state = nil
      }

      it("has targets") {
        expect(state.targets.count).to(equal(1))
        expect(state.targets).to(containElementSatisfying({ target in
          return target.api == "first-api" && target.team == "first-team"
        }))
      }

      context("within the targets") {
        var target: Concourse.Target!

        beforeEach {
          target = state.targets[0]
        }

        afterEach {
          target = nil
        }

        it("has pipelines") {
          expect(target.pipelines.count).to(equal(4))
          expect(target.pipelines).to(containElementSatisfying({ pipeline in
            return pipeline.id == 1 && pipeline.name == "first-pipeline"
          }))
          expect(target.pipelines).to(containElementSatisfying({ pipeline in
            return pipeline.id == 2 && pipeline.name == "second-pipeline"
          }))
          expect(target.pipelines).to(containElementSatisfying({ pipeline in
            return pipeline.id == 3 && pipeline.name == "third-pipeline"
          }))
          expect(target.pipelines).to(containElementSatisfying({ pipeline in
            return pipeline.id == 4 && pipeline.name == "fourth-pipeline"
          }))
        }

        context("within the pipelines") {
          var pipeline1: Concourse.Pipeline!
          var pipeline2: Concourse.Pipeline!
          var pipeline3: Concourse.Pipeline!
          var pipeline4: Concourse.Pipeline!

          beforeEach {
            pipeline1 = target.pipelines[0]
            pipeline2 = target.pipelines[1]
            pipeline3 = target.pipelines[2]
            pipeline4 = target.pipelines[3]
          }

          it("has groups") {
            expect(pipeline1.groups.count).to(equal(1))
            expect(pipeline1.groups).to(containElementSatisfying({ group in
              return group.name == "first-group"
            }))

            expect(pipeline2.groups.count).to(equal(1))
            expect(pipeline2.groups).to(containElementSatisfying({ group in
              return group.name == "second-group"
            }))

            expect(pipeline3.groups.count).to(equal(1))
            expect(pipeline3.groups).to(containElementSatisfying({ group in
              return group.name == "third-group"
            }))

            expect(pipeline4.groups.count).to(equal(1))
            expect(pipeline4.groups).to(containElementSatisfying({ group in
              return group.name == "fourth-group"
            }))
          }

          it("has jobs") {
            expect(pipeline1.jobs.count).to(equal(4))
            expect(pipeline1.jobs).to(containElementSatisfying({ job in
              return job.name == "first-job"
            }))
            expect(pipeline1.jobs).to(containElementSatisfying({ job in
              return job.name == "second-job"
            }))
            expect(pipeline1.jobs).to(containElementSatisfying({ job in
              return job.name == "third-job"
            }))
            expect(pipeline1.jobs).to(containElementSatisfying({ job in
              return job.name == "fourth-job"
            }))

            expect(pipeline2.jobs.count).to(equal(4))
            expect(pipeline2.jobs).to(containElementSatisfying({ job in
              return job.name == "first-job"
            }))
            expect(pipeline2.jobs).to(containElementSatisfying({ job in
              return job.name == "second-job"
            }))
            expect(pipeline2.jobs).to(containElementSatisfying({ job in
              return job.name == "third-job"
            }))
            expect(pipeline2.jobs).to(containElementSatisfying({ job in
              return job.name == "fourth-job"
            }))

            expect(pipeline3.jobs.count).to(equal(4))
            expect(pipeline3.jobs).to(containElementSatisfying({ job in
              return job.name == "first-job"
            }))
            expect(pipeline3.jobs).to(containElementSatisfying({ job in
              return job.name == "second-job"
            }))
            expect(pipeline3.jobs).to(containElementSatisfying({ job in
              return job.name == "third-job"
            }))
            expect(pipeline3.jobs).to(containElementSatisfying({ job in
              return job.name == "fourth-job"
            }))

            expect(pipeline4.jobs.count).to(equal(4))
            expect(pipeline4.jobs).to(containElementSatisfying({ job in
              return job.name == "first-job"
            }))
            expect(pipeline4.jobs).to(containElementSatisfying({ job in
              return job.name == "second-job"
            }))
            expect(pipeline4.jobs).to(containElementSatisfying({ job in
              return job.name == "third-job"
            }))
            expect(pipeline4.jobs).to(containElementSatisfying({ job in
              return job.name == "fourth-job"
            }))
          }

          context("within the groups") {
            var group1: Concourse.Group!
            var group2: Concourse.Group!
            var group3: Concourse.Group!
            var group4: Concourse.Group!

            beforeEach {
              group1 = pipeline1.groups[0]
              group2 = pipeline2.groups[0]
              group3 = pipeline3.groups[0]
              group4 = pipeline4.groups[0]
            }

            it("has jobs") {
              expect(group1.jobs.count).to(equal(1))
              expect(group1.jobs).to(containElementSatisfying({ job in
                return job.name == "first-job"
              }))

              expect(group2.jobs.count).to(equal(1))
              expect(group2.jobs).to(containElementSatisfying({ job in
                return job.name == "second-job"
              }))

              expect(group3.jobs.count).to(equal(1))
              expect(group3.jobs).to(containElementSatisfying({ job in
                return job.name == "third-job"
              }))

              expect(group4.jobs.count).to(equal(1))
              expect(group4.jobs).to(containElementSatisfying({ job in
                return job.name == "fourth-job"
              }))
            }
          }
        }
      }
    }

    describe("fetchAndNotify") {
      it("notifies the delegates when the state changes") {
        manager.fetchAndNotify()

        let firstState = firstDelegate.stateDidChangeCall.receives.state
        let secondState = secondDelegate.stateDidChangeCall.receives.state

        expect(firstState?.targets.count).to(equal(1))
        expect(firstState?.targets).to(containElementSatisfying({ target in
          return target.api == "first-api" && target.team == "first-team"
        }))

        expect(secondState?.targets.count).to(equal(1))
        expect(secondState?.targets).to(containElementSatisfying({ target in
          return target.api == "first-api" && target.team == "first-team"
        }))
      }

      context("when there are errors") {
        it("logs those errors") {
          pipelinesService.listCall.returns.error = TestableErrors.String("this is an error")

          manager.fetchAndNotify()

          expect(logger.errorCall.receives.message).to(equal("failed to fetch concourse state"))
          expect(logger.errorCall.receives.error).to(matchError(TestableErrors.String("this is an error")))
        }
      }
    }
  }
}
