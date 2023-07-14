% ETSletter.cls
% 
% Author: Marcos Dias de Assuncao, July 2023.
% 
% A document class for letters with the Ecole de technologie 
% superieure (ETS) letterhead. 
% 
% Notes:
% 1. This class follows the ETS guidelines specified in the guide entitled
%    "Image de marque ÉTS", Section Applications, page 2.
% 2. The logos are PDF versions of the AI/EPS files available at ETS' website.
% 3. You need to compile the document using XeLaTeX because this class uses
%    the Delta Jaeger font family as recommended by ETS guidelines.
% 4. ETS' "Image de marque ÉTS" uses a unit of dimension called "E", which is
%    essentially the size of the E of ETS in the logo. However, it does not 
%    specify the size of E proportionally to the logo's size. As the logo in
%    the letter is 1 inch high, as per my calculations an "E" here corresponds 
%    to 0.3 inches.
% 5. This class uses the eforms package to create the signature field:
%    https://www.ctan.org/pkg/eforms
%    The package is part of the "The AcroTeX education bundle" and is included 
%    here in the ./acrodex directory as it is included as a Contrib in TexLive.
%
%
\NeedsTeXFormat{LaTeX2e}
% \hfuzz=1000pt % Just to get rid of the annoying box overfull warnings
\ProvidesClass{ETSletter}[2023/07/14 ETS Letter]
\RequirePackage{kvoptions}
\DeclareStringOption[english]{language}

\DeclareVoidOption{10pt}{\PassOptionsToClass{10pt}{letter}}
\DeclareVoidOption{11pt}{\PassOptionsToClass{11pt}{letter}}
\DeclareVoidOption{12pt}{\PassOptionsToClass{12pt}{letter}}

% Used to checks whether to created a signature field 
\DeclareBoolOption[false]{signature}

\ProcessKeyvalOptions*

\LoadClass[letterpaper]{letter}
\RequirePackage{calc}
\RequirePackage{geometry}
\RequirePackage{ifthen}
\RequirePackage[x11names]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{etoolbox}
\RequirePackage{fontspec}
\RequirePackage{setspace}
\RequirePackage[absolute,overlay]{textpos}
\RequirePackage[document]{ragged2e}
\RequirePackage[hidelinks]{hyperref}


% As per the guidelines, the top part of the content 
% should be aligned with the bottom of the logo
\raggedbottom

% Last page seems to complain if imported before eforms
\RequirePackage{lastpage}

\ifETSletter@signature
  \typeout{Signature field is required.}
  \def\input@path{{./acrotex}}
  \RequirePackage{eforms}
\else
  \typeout{Signature field not required.}
\fi


% Sets babel and redefines the commands according to the language
\ifcase\pdfstrcmp{\ETSletter@language}{english}
  \typeout{ETS Letter in English.}
  \PassOptionsToPackage{main=english,french,spanish}{babel}
  \def\ETSletter@substart{Subject:}
  \def\ETSletter@logo{Logo_ETS_EN}
  \newcommand{\ETSletter@city}{Montreal}
  \newcommand{\ETSletter@datepref}{}
\or 
  \ifcase\pdfstrcmp{\ETSletter@language}{french}
    \typeout{ETS Letter in French.}
    \PassOptionsToPackage{main=french,english,spanish}{babel}
    \def\ETSletter@substart{Objet :}
    \def\ETSletter@logo{Logo_ETS_FR}
    \newcommand{\ETSletter@city}{Montréal}
    \newcommand{\ETSletter@datepref}{le}
  \or
    \ifcase\pdfstrcmp{\ETSletter@language}{spanish}
      \typeout{ETS Letter in Spanish.}
      \PassOptionsToPackage{main=spanish,english,french}{babel}
      \def\ETSletter@substart{Asunto:}
      \def\ETSletter@logo{Logo_ETS_ESP}
      \newcommand{\ETSletter@city}{Montreal}
      \newcommand{\ETSletter@datepref}{}
    \else
      \ClassError{ETSletter}{Invalid language option: '\ETSletter@language'}{}
    \fi
  \fi
\fi 

\RequirePackage{babel}

% Creates a dimension with the size of E in ETS, 
% according to the "Image de marque ÉTS" document.
\newlength{\ETS@E}
\setlength{\ETS@E}{0.3in}

% According to the document "Image de marque ÉTS", the top, left 
% and right margins are one "E". The text offset is: "E" + logo width + 3 * E  
\geometry{ 
    paper=letterpaper,    % North America does not seem to have embraced ISO A4, we always use letter
    lmargin=\dimexpr\ETS@E * 4 + 1in,  % E + logo width + 3 * E
    rmargin=\ETS@E,                    % 1 E
    marginparwidth=\ETS@E,             % 1 E
    bottom=\dimexpr\ETS@E * 2, % The guide does not mention it, but it looks like 2 * E
    top=1in+\ETS@E,            % Top margin for text aligned with bottom of logo (E + 1 inch) 
    hcentering=false,
    vcentering=false
}

% According to ETS guidelines, content should use the Delta Jaeger font family
\setmainfont{delta-light}[
    Path = ./fonts/, 
    Extension = .ttf,
    BoldFont = delta-book, 
    ItalicFont = delta-light-italic,
    BoldItalicFont = delta-book-italic,
    Ligatures=TeX
]

% ETS commands
\def\ETSletter@name{}
\newcommand{\ETSphone}[1]{\def\ETSletter@phone{#1}}
\newcommand{\ETSdepartment}[1]{\def\ETSletter@department{#1}}
\newcommand{\ETSname}[1]{\def\ETSletter@name{#1}}

\newcommand{\ETScity}[1]{
  \renewcommand{\ETSletter@city}{#1}
}

% Adapt the subject label to the used language
\newcommand{\ETSletter@subject}{}
\newcommand{\subject}[1]{
  \renewcommand{\ETSletter@subject}{{\ETSletter@substart } #1}
}

% The guide says "address block in black 75%/85%" 
\definecolor{address}{rgb}{0.25, 0.25, 0.25}
\parindent 0pt 

\def\ETSletter@header{
  \begin{textblock*}{4in}(\ETS@E, \ETS@E)
    \includegraphics[width=1.in]{logos/\ETSletter@logo}
  \end{textblock*}
}

\def\ETSletter@footer{
  \begin{textblock*}{4in}(\dimexpr \ETS@E + 0.03in, \dimexpr\paperheight-\footskip-2in)
    \begin{minipage}[b][2in][b]{\linewidth}
        \raggedright{
        \setstretch{1.3}\fontsize{8.4}{8.4}\selectfont
        {\color{address}\textbf{ÉCOLE DE\\TECHNOLOGIE\\SUPÉRIEURE}}\\
        \vspace{0.08in}
        \fontsize{7.5}{7.5}\selectfont{
        Université du Québec\\
        \vspace{\ETS@E}
        \textbf{\ETSletter@department}}\\
        1100, rue Notre-Dame Ouest\\
        Montréal (Québec) H3C 1K3\\
        \vspace{0.1in}
        \ETSletter@phone\\
        etsmtl.ca}  
    \end{minipage}
  \end{textblock*}
  \begin{textblock*}{0.5in}(\dimexpr\paperwidth-0.5in, \dimexpr\paperheight-\footskip-0.5in)
    \begin{minipage}[b][0.5in][b]{\linewidth}
      \pagenumber
    \end{minipage}
  \end{textblock*}
}

% Redefine the headers and footers
\renewcommand{\ps@plain}{%
  \renewcommand{\@oddhead}{\ETSletter@header} 
  \renewcommand{\@oddfoot}{\ETSletter@footer} 
  \renewcommand{\@evenhead}{\ETSletter@header} 
  \renewcommand{\@evenfoot}{\ETSletter@footer} 
}

\renewcommand{\ps@empty}{
  \renewcommand{\@oddhead}{\ETSletter@header} 
  \renewcommand{\@oddfoot}{\ETSletter@footer} 
  \renewcommand{\@evenhead}{\ETSletter@header} 
  \renewcommand{\@evenfoot}{\ETSletter@footer} 
}

\newcommand{\pagenumber}{
    \ifthenelse{\equal{\thepage}{}}{}{
        {\fontsize{8}{8}\selectfont \thepage/\pageref{LastPage}}
    }
}

% We must include the subject in the opening.
\renewcommand{\opening}[1]{\thispagestyle{plain}%
    \textbf{\ifx\ETSletter@city\empty Montreal \else \ETSletter@city \fi,} 
    \textbf{{\ETSletter@datepref }\@date}\par
    \medskip
    {\raggedright \toname \\ \toaddress \par}%
    \ifx\toaddress\empty \else \medskip \fi    
    \vspace{1\parskip}
    \ifthenelse{\equal{\ETSletter@subject}{}}{}{\textbf{\ETSletter@subject}\par}
    \vspace{1\parskip}%
    #1\par\nobreak
}

% We force closing to the left.
\renewcommand{\closing}[1]{\par\nobreak\vspace{\parskip}%
\stopbreaks
    \noindent
    \parbox{1.\textwidth}{\raggedright
    \ignorespaces #1\\[4\medskipamount]%
    }
    % As per the new guidelines, the signature should be more or less aligned with the address.
    % So, we force a vertical fill here.
    \vfill
    \ifETSletter@signature%
      \sigField[\BC{0.25 0.25 0.25}] {ETSSign}{2in}{4\baselineskip}\\ %
    \fi
    \ifx\@empty\ETSletter@name \else \ETSletter@name \fi
    \ifx\@empty\fromsig
    \fromname
    \else \fromsig\raggedright 
    \fi\strut
    \par
    \ifx\@empty\fromaddress\else
    \fromaddress
    \fi 
}

\parskip 10pt plus2pt minus2pt
\pagestyle{empty} 
