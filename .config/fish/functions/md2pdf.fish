function md2pdf --description 'Convert md to pdb via pandoc and open generated pdf' --argument md_path
    set pdf_path (basename $md_path .md).pdf
    pandoc $md_path \
        --pdf-engine=xelatex \
        -f markdown-smart \
        --filter pandoc-fignos \
        -t latex-smart \
        -o $pdf_path \
        $argv[2..-1]
    and open $pdf_path
end
