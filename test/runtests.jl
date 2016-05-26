using Project
using Base.Test

test_project = "test_project"

function test_new_project()
  Project.new(test_project,"0.0.1")
  return readall(open(string(pwd(),"/",test_project,"/project.json"))) != ""
end

function test_add_deps()
  cd(test_project)
  Project.add("MNIST")
  return get(Pkg.installed(),"MNIST",0) != 0
end

# write your own tests here
@test 1 == 1
@test test_new_project()
@test test_add_deps()

cd("..")
rm(test_project,recursive=true)
