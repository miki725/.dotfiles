function md2pdf-ieee --description 'Convert md to pdb via pandoc with ieee format and open generated pdf' --argument md_path pdf_path
    if test -z "$pdf_path"
        set pdf_path (basename $md_path .md).pdf
    end

    mkdir -p ~/.pandoc

    set -gx PYTHONPATH (pandocfilters.sh --python)
    set pandoc_path ~/.pandoc
    set bibliography_path /tmp/bibliography-(openssl rand -hex 10).bib
    set ieee_path $pandoc_path/IEEEtran.cls
    set template_path $pandoc_path/template-ieee.latex
    set bibliography_csl_path $pandoc_path/bibliography-ieee.csl
    set table_filter_path $pandoc_path/table-filter.py

    if not test -f $ieee_path
        curl https://raw.githubusercontent.com/miki725/md2pdf-ieee/master/IEEEtran.cls \
            > $ieee_path
    end
    if not test -f $bibliography_csl_path
        curl https://raw.githubusercontent.com/miki725/md2pdf-ieee/master/bibliography.csl \
            > $bibliography_csl_path
    end
    if not test -f $table_filter_path
        curl https://raw.githubusercontent.com/miki725/md2pdf-ieee/master/table-filter.py \
            > $table_filter_path
    end
    if not test -f $template_path
        curl https://raw.githubusercontent.com/miki725/md2pdf-ieee/master/template.latex \
            | sed "s#IEEEtran#$HOME/.pandoc/IEEEtran#" \
            | python -c '
import itertools
import sys
data = sys.stdin.read()
lines = data.splitlines()
replacement = """
$if(author)$
\\\\author{
    $for(author)$
        \\\\IEEEauthorblockN{$author.name$}
        $if(author.affiliation)$
        \\\\IEEEauthorblockA{\\\\\\ $author.affiliation$}
        $endif$
        $if(author.location)$
        \\\\IEEEauthorblockA{\\\\\\ $author.location$}
        $endif$
        $if(author.email)$
        \\\\IEEEauthorblockA{\\\\\\ $author.email$}
        $endif$
        $sep$ \\\\and
    $endfor$
}
$endif$
"""
to_replace = "\n".join(
    itertools.takewhile(
        lambda i: i.strip(),
        itertools.dropwhile(
            lambda i: "(author)" not in i,
            lines
        )
    )
)
print(data.replace(to_replace, replacement.strip()).strip())
            ' \
            > $template_path
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

    set -l command pandoc $md_path \
        -f markdown+tex_math_single_backslash \
        -t latex \
        -o $pdf_path \
        --standalone \
        --pdf-engine=xelatex \
        --filter=(which pandoc-crossref) \
        --filter=(which pandoc-citeproc) \
        --filter=$table_filter_path \
        --bibliography=$bibliography_path \
        --csl=$bibliography_csl_path \
        --template=$template_path
    $command
    and open --background $pdf_path
    and rm -f $bibliography_path
    and rm -f '/tmp/bibliography*.bib'
    and echo (date) "Generated PDF"
    or echo $command
end
