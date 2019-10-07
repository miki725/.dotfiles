function md2pdf --description 'Convert md to pdb via pandoc and open generated pdf' --argument md_path pdf_path
    if test -z "$pdf_path"
        set pdf_path (basename $md_path .md).pdf
    end
    pandoc $md_path -f markdown -t latex -o $pdf_path
    open $pdf_path
end
