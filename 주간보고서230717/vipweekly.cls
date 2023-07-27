\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{vipweekly}[2015/01/01 Standard LaTeX package]

%% Article options
\DeclareOption{10pt}{
  \PassOptionsToClass{\CurrentOption}{article}
}
\DeclareOption{11pt}{
  \PassOptionsToClass{\CurrentOption}{article}
}

%% Fallback
\DeclareOption*{
  \ClassWarning{vipweekly}{Unknown option '\CurrentOption'}
}

%% Execute default options
\ExecuteOptions{11pt}

%% Process given options
\ProcessOptions\relax

%% Load base
\LoadClass[a4paper]{article}

%% Load additional packages and commands.
\PassOptionsToPackage{nonfrench}{dhucs}
\PassOptionsToPackage{english}{babel}
\PassOptionsToPackage{pdftex}{graphicx}
\PassOptionsToPackage{super}{nth}
\PassOptionsToPackage{tmargin = 0.8in, hmargin=0.6in, bmargin=1in}{geometry}
\RequirePackage{geometry}
\RequirePackage{dhucs}
\RequirePackage{array, booktabs}
\RequirePackage{babel}
\RequirePackage{mathtools}
\RequirePackage{graphicx}
\RequirePackage{fancyhdr}
\RequirePackage{nth}
\RequirePackage{subfig}
\RequirePackage{multirow}
\RequirePackage{here}
\RequirePackage{standalone}
\RequirePackage{xparse}

%% Additional TeX/LaTeX code...
\makeatletter
\newcommand{\ts}{\textsuperscript}
\renewcommand{\arraystretch}{1.2}
\newcommand*{\rom}[1]{\expandafter\@slowromancap\romannumeral #1@}
\newlength{\rowwidth}
\setlength{\rowwidth}{15pt}
\newcommand{\arrow}[2]{\multicolumn{#1}{c|}{$\xleftrightarrow{\hspace*{#2}}$}}
\newcommand{\tblcontent}[3]{\multicolumn{#1}{p{#2\rowwidth}|}{#3}}
\renewcommand{\headrulewidth}{0pt}
\newcommand{\insertgrade}{M.S. Candidate}
\newcommand{\inserttitle}{Title}
\newcommand{\insertauthor}{Author}
\newcommand{\insertdate}{Date}
\newcommand{\grade}[1]{\renewcommand{\insertgrade}{#1}}
\renewcommand{\title}[1]{\renewcommand{\inserttitle}{#1}}
\renewcommand{\author}[1]{\renewcommand{\insertauthor}{#1}}
\renewcommand{\date}[1]{\renewcommand{\insertdate}{#1}}
\pagestyle{fancy}
\lhead{\textsc{Visual Information Processing Lab.}}
\chead{}
\rhead{\insertdate}
\newcommand{\HRule}{\rule{\linewidth}{0.5mm}}
\setlength{\headheight}{25pt}

\ExplSyntaxOn
\DeclareExpandableDocumentCommand{\juliandate}{ m m m }
 {
  \juliandate_calc:nnnn { #1 } { #2 } { #3 } { \use:n }
 }
\NewDocumentCommand{\storejuliandate}{ s m m m m }
 {
  \IfBooleanTF{#1}
   {
    \juliandate_calc:nnnn { #3 } { #4 } { #5 } { \cs_set:Npx #2 }
   }
   {
    \juliandate_calc:nnnn { #3 } { #4 } { #5 } { \cs_new:Npx #2 }
   }
 }
\cs_new:Npn \juliandate_calc:nnnn #1 #2 #3 #4 % #1 = day, #2 = month, #3 = year, #4 = what to do
 {
  #4 
   {
    \int_eval:n
     {
      #1 +
      \int_div_truncate:nn { 153 * (#2 + 12 * \int_div_truncate:nn { 14 - #2 } { 12 } - 3) + 2 } { 5 } +
      365 * (#3 + 4800 - \int_div_truncate:nn { 14 - #2 } { 12 } ) +
      \int_div_truncate:nn { #3 + 4800 - \int_div_truncate:nn { 14 - #2 } { 12 } } { 4 } -
      \int_div_truncate:nn { #3 + 4800 - \int_div_truncate:nn { 14 - #2 } { 12 } } { 100 } + 
      \int_div_truncate:nn { #3 + 4800 - \int_div_truncate:nn { 14 - #2 } { 12 } } { 400 } -
      32045
     }
   }
 }

\tl_new:N \l__juliandate_g_tl
\tl_new:N \l__juliandate_dg_tl
\tl_new:N \l__juliandate_c_tl
\tl_new:N \l__juliandate_dc_tl
\tl_new:N \l__juliandate_b_tl
\tl_new:N \l__juliandate_db_tl
\tl_new:N \l__juliandate_a_tl
\tl_new:N \l__juliandate_da_tl
\tl_new:N \l__juliandate_y_tl
\tl_new:N \l__juliandate_m_tl
\tl_new:N \l__juliandate_d_tl
\int_new:N \l_juliandate_day_int
\int_new:N \l_juliandate_month_int
\int_new:N \l_juliandate_year_int

\cs_new:Npn \__juliandate_set:nn #1 #2
 {
  \tl_set:cx { l__juliandate_#1_tl } { \int_eval:n { #2 } }
 }
\cs_new:Npn \__juliandate_use:n #1
 {
  \tl_use:c { l__juliandate_#1_tl }
 }
\cs_new_protected:Npn \juliandate_reverse:n #1
 {
  \__juliandate_set:nn { g }
   { \int_div_truncate:nn { #1 + 32044 } { 146097 } }
  \__juliandate_set:nn { dg }
   { \int_mod:nn { #1 + 32044 } { 146097 } }
  \__juliandate_set:nn { c }
   { \int_div_truncate:nn { ( \int_div_truncate:nn { \__juliandate_use:n { dg } } { 36524 } + 1) * 3 } { 4 } }
  \__juliandate_set:nn { dc }
   { \__juliandate_use:n { dg } - \__juliandate_use:n { c } * 36524 }
  \__juliandate_set:nn { b }
   { \int_div_truncate:nn { \__juliandate_use:n { dc } } { 1461 } }
  \__juliandate_set:nn { db }
   { \int_mod:nn { \__juliandate_use:n { dc } } { 1461 } }
  \__juliandate_set:nn { a }
   { \int_div_truncate:nn { ( \int_div_truncate:nn { \__juliandate_use:n { db } } { 365 } + 1) * 3 } { 4 } }
  \__juliandate_set:nn { da }
   { \__juliandate_use:n { db } - \__juliandate_use:n { a } * 365 }
  \__juliandate_set:nn { y }
   {
     \__juliandate_use:n { g } * 400 + 
     \__juliandate_use:n { c } * 100 + 
     \__juliandate_use:n { b } * 4 + 
     \__juliandate_use:n { a }
    }
  \__juliandate_set:nn { m }
   { \int_div_truncate:nn { \__juliandate_use:n { da } * 5 + 308 } { 153 } - 2 }
  \__juliandate_set:nn { d }
   { \__juliandate_use:n { da } - \int_div_truncate:nn { (\__juliandate_use:n { m } + 4) * 153 } { 5 } + 122 }
  \int_set:Nn \l_juliandate_year_int
   { \__juliandate_use:n { y } - 4800 + \int_div_truncate:nn { \__juliandate_use:n { m } + 2 } { 12 } }
  \int_set:Nn \l_juliandate_month_int
   { \int_mod:nn { \__juliandate_use:n { m } + 2 } { 12 } + 1 }
  \int_set:Nn \l_juliandate_day_int
   { \__juliandate_use:n { d } + 1 }
 }
\cs_generate_variant:Nn \juliandate_reverse:n { x }

\NewDocumentCommand{\showday}{ m }
 {
  \juliandate_reverse:n { #1 }
  \int_to_arabic:n { \l_juliandate_day_int }-
  \int_to_arabic:n { \l_juliandate_month_int }-
  \int_to_arabic:n { \l_juliandate_year_int }
 }

\NewDocumentCommand{\tomorrow}{ }
 {
  \group_begin:
  \juliandate_reverse:x { \juliandate_calc:nnnn { \day + 1 } { \month } { \year } { \use:n } }
  \day = \l_juliandate_day_int
  \month = \l_juliandate_month_int
  \year = \l_juliandate_year_int
  \today
  \group_end:
 }
\NewDocumentCommand{\tomorrowof}{ m m m }
 {
  \group_begin:
  \juliandate_reverse:x { \juliandate_calc:nnnn { #1 + 1 } { #2 } { #3 } { \use:n } }
  \day = \l_juliandate_day_int
  \month = \l_juliandate_month_int
  \year = \l_juliandate_year_int
  \today
  \group_end:
 }
\ExplSyntaxOff

\renewcommand{\maketitle}{
  \begin{center}
  { \huge \bfseries \inserttitle \\[0.2cm] }
  \begin{flushright}
  \large \textsc{Visual Information Processing Lab.} \\
  \large \insertgrade\\
  \large \insertauthor
  \end{flushright}
  \end{center}
}
\makeatother

\endinput
