module Project

import JSON
# package code goes here

export new

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

end # module
