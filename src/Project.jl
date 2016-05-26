module Project

import JSON
# package code goes here

export new,add

function new(project_name::AbstractString,version::AbstractString,project_directory::AbstractString="pwd")
  if (project_directory == "pwd")
    project_directory = pwd()
  elseif project_directory[1] == '.'
    project_directory = string(pwd(),"/",project_directory)
  end
  cd(project_directory)
  mkdir(project_name)
  cd(project_name)
  project_settings = Dict(
    "name" => project_name,
    "version" => version,
    "dependencies" => []
  )
  json_string = JSON.json(project_settings)
  project_file = open("./project.json", "w")
  write(project_file,json_string)
  close(project_file)
  print("Your project was created successfully.")
end

function add(package_name::AbstractString)
  project_directory = pwd()
  cd(project_directory)
  if (isfile("./project.json"))
    project_file = open("./project.json")
    project_settings = JSON.parse(readall(project_file))
    push!(project_settings["dependencies"],("pkg",package_name))
    try
      if (get(Pkg.installed(), package_name, 0) == 0)
        Pkg.add(package_name)
      end
      project_file = open("./project.json","w")
      json_string = JSON.json(project_settings)
      write(project_file,json_string)
    catch e
      println(string("\x1b[31m","\x1b[1m","An error occured while installing the package $package_name via Pkg.add"))
    end
    close(project_file)
  end
end

end # module
