main_dir <- "foo"

dir.create(file.path(main_dir, su))

file.path("C:", "Users", "John", "Documents", fsep="/")
file.path("E:", "R","Projects", fsep = "/")
path.expand("e")
main_dir <- path.expand("~/fo")
path.expand("~",main_dir)
getwd()


sub_dir_exist <- "subdir_example"
dir.create(file.path(main_dir, sub_dir_exist))
dir.create(file.path(main_dir, sub_dir_exist))

sub_dir_new <- "subdir_new"
dir.create(file.path(main_dir, sub_dir_new))
if(dir.exists(main_dir)){dir.create("foopo")}
dir.create(main_dir)
main_dir <- file.path(getwd(), "dataexpo", fsep = "/")
