module Project

import JSON

export new,add

function new(project_name::AbstractString,version::AbstractString,project_directory::AbstractString="pwd")
  original_pwd = pwd()
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
  cd(original_pwd)
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

function set_version(new_version_string)
  project_directory = pwd()
  cd(project_directory)
  if (isfile("./project.json"))
    project_file = open("./project.json")
    project_settings = JSON.parse(readall(project_file))
    project_settings["version"] = new_version_string
    project_file = open("./project.json","w")
    json_string = JSON.json(project_settings)
    write(project_file,json_string)
  end
end

function install_dependencies(force_reinstall=false)
  project_directory = pwd()
  cd(project_directory)
  if (isfile("./project.json"))
    project_file = open("./project.json")
    project_settings = JSON.parse(readall(project_file))
    for dep in project_settings["dependencies"]
      if dep[1] == "pkg"
        if (get(Pkg.installed(), dep[2], 0) == 0)
          Pkg.add(dep[2])
        elseif force_reinstall
          Pkg.rm(dep[2])
          Pkg.add(dep[2])
        end
      end
    end
  else
    print_with_color(:red,"ERROR: There is no project.json file in your current directory.\n")
  end
end

end # module
