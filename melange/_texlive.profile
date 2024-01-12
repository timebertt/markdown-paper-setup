cat <<EOF > texlive.profile
selected_scheme scheme-custom
TEXDIR /usr/local/texlive
TEXMFCONFIG ~/.texlive/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL /usr/local/texlive/texmf-local
TEXMFSYSCONFIG /usr/local/texlive/texmf-config
TEXMFSYSVAR /usr/local/texlive/texmf-var
TEXMFVAR ~/.texlive/texmf-var
binary_aarch64-linux 1
collection-basic 1
collection-langenglish 1
collection-langgerman 1
collection-latex 1
collection-latexrecommended 1
instopt_adjustpath 1
instopt_adjustrepo 1
instopt_letter 0
instopt_portable 0
instopt_write18_restricted 1
tlpdbopt_autobackup 1
tlpdbopt_backupdir tlpkg/backups
tlpdbopt_create_formats 1
tlpdbopt_desktop_integration 1
tlpdbopt_file_assocs 1
tlpdbopt_generate_updmap 0
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
tlpdbopt_post_code 1
tlpdbopt_sys_bin /usr/local/bin
tlpdbopt_sys_info /usr/local/share/info
tlpdbopt_sys_man /usr/local/share/man
tlpdbopt_w32_multi_user 1
EOF




cat <<EOF > texlive.profile
selected_scheme scheme-custom
TEXDIR /usr/share/texlive
TEXMFCONFIG ~/.texlive/texmf-config
TEXMFHOME ~/texmf
TEXMFLOCAL /usr/share/texlive/texmf-local
TEXMFSYSCONFIG /usr/share/texlive/texmf-config
TEXMFSYSVAR /usr/share/texlive/texmf-var
TEXMFVAR ~/.texlive/texmf-var
binary_aarch64-linux 1
collection-basic 1
instopt_adjustpath 1
instopt_adjustrepo 1
instopt_letter 0
instopt_portable 0
instopt_write18_restricted 1
tlpdbopt_autobackup 1
tlpdbopt_backupdir tlpkg/backups
tlpdbopt_create_formats 1
tlpdbopt_desktop_integration 1
tlpdbopt_file_assocs 1
tlpdbopt_generate_updmap 0
tlpdbopt_install_docfiles 0
tlpdbopt_install_srcfiles 0
tlpdbopt_post_code 1
tlpdbopt_sys_bin /usr/local/bin
tlpdbopt_sys_info /usr/local/share/info
tlpdbopt_sys_man /usr/local/share/man
tlpdbopt_w32_multi_user 1
EOF
