-- Filetype registrations.
vim.filetype.add({
  extension = {
    puml = 'plantuml',
    sh = 'sh',
    bash = 'sh',
  },
  pattern = {
    -- Match any shell script file by extension, even without shebang
    ['.*%.sh'] = 'sh',
    ['.*%.bash'] = 'sh',
  },
});

