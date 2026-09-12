{
    programs.neovim.vimOptions = {
        number = true;
        relativenumber = true;
        signcolumn = "yes";
        cursorline = true;
        list = true;
        listchars = {
            extends = ">";
            precedes = "<";
            tab = "  ";
            trail = "•";
        };

        smartcase = true;
        ignorecase = true;

        undofile = true;
    };
}

# vim: sw=4:
