function add-gpg-signature-to-md --argument file
    cat $file
    echo -e '\\pagebreak\n```'
    cat $file | gpg --sign --armor | cat
    echo -e '```'
end
