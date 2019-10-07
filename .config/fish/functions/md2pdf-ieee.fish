function md2pdf-ieee --description 'Convert md to pdb via pandoc with ieee format and open generated pdf' --argument md_path pdf_path
    if test -z "$pdf_path"
        set pdf_path (basename $md_path .md).pdf
    end

    mkdir -p ~/.pandoc

    set pandoc_path ~/.pandoc
    set bibliography_path /tmp/bibliography-(openssl rand -hex 10).bib
    set template_path $pandoc_path/template-ieee.latex
    set bibliography_csl_path $pandoc_path/bibliography-ieee.csl

    if not test -f $template_path
        curl https://raw.githubusercontent.com/miki725/md2pdf-ieee/master/template.latex > $template_path
    end
    if not test -f $bibliography_csl_path
        curl https://raw.githubusercontent.com/miki725/md2pdf-ieee/master/bibliography.csl > $bibliography_csl_path
    end

    cat $md_path | python -c "
import itertools
import sys
print('\n'.join(
    list(
        map(
            lambda i: i.strip(),
            itertools.takewhile(
                lambda i: i.strip() != i or i.startswith('bibliography'),
                itertools.dropwhile(
                    lambda i: not i.startswith('bibliography'),
                    sys.stdin.read().splitlines()
                ),
            )
        )
    )[1:]
))
" > $bibliography_path

    pandoc $md_path \
        -f markdown \
        -t latex \
        -o $pdf_path \
        --standalone \
        --bibliography=$bibliography_path \
        --csl=$bibliography_csl_path \
        --template=$template_path
    open $pdf_path

    rm -f $bibliography_path
    rm -f '/tmp/bibliography*.bib'
end
