-- histogram groups moved/reordered code into cleaner hunks than the default myers.
-- linematch aligns similar lines inside a hunk so changed lines pair up side by side
-- (raised from default 40 for bigger refactors)
vim.opt.diffopt:remove("linematch:40")
vim.opt.diffopt:append({ "algorithm:histogram", "linematch:60" })
