local status_ok, jdtls = pcall(require, 'jdtls')
if not status_ok then
  return
end

local config = {
    cmd = {'C:\\Users\\servicelaptop\\AppData\\Local\\nvim-data\\mason\\bin\\jdtls.cmd'},
    root_dir = vim.fs.dirname(vim.fs.find({'.gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
jdtls.start_or_attach(config)
