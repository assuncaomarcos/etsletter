% ETSletter.cls 
% A document class for letters with the Ecole de technologie superieure (ETS) letterhead. 
% Some commands were adapted from "VTletter.cls", copyright January/February 2018, 
% by Robert Browder and Carrie Cross from Virginia Tech. 
% 
% This class version is by Marcos Dias de Assuncao, August 2021.
% 
% Notes:
% 1. This class follows the ETS guidelines specified in the document entitled
%    "Guide des normes graphiques", page 11, "Papier à lettre standard" available at: 
%    https://www.etsmtl.ca/ets/gouvernance/logos-et-normes-graphiques#Guides
% 2. The logos are PDF versions of the AI/EPS files available at ETS' website.
% 3. You need to compile the document using XeLaTeX because this class uses
%    the Delta Jaeger font family as recommended by ETS guidelines.
%
\NeedsTeXFormat{LaTeX2e}
\hfuzz=1000pt % Just to get rid of the annoying box overfull warnings
\ProvidesClass{ETSletter}
\DeclareOption{10pt}{\PassOptionsToClass{10pt}{letter}}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{letter}}
\DeclareOption{12pt}{\PassOptionsToClass{12pt}{letter}}
\DeclareOption{english}{\def\@english{english}}
\ProcessOptions
\LoadClass[letterpaper]{letter}

\RequirePackage{calc}
\RequirePackage{geometry}
\RequirePackage{ifthen}
\RequirePackage[x11names]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{etoolbox}
\RequirePackage{fontspec}
\RequirePackage{setspace}
\RequirePackage[absolute]{textpos}
\RequirePackage{lastpage}

% Create an ifEnglish just for convenience 
\newif\ifEnglish  \Englishfalse
\ifundef{\@english}
{\setboolean{English}{false}}
{\setboolean{English}{true}}

% Configure babel with the proper language to 
% set stuff like dates, space before :, etc
\ifEnglish
{\PassOptionsToPackage{english}{babel}}
\else{\PassOptionsToPackage{french}{babel}}
\fi
\RequirePackage{babel}

% Helper command to enable bilingual versions of content
\newcommand{\bilingual}[2]{\ifEnglish{#1}\else{#2}\fi}

% Adapt the subject label to the used language
\newcommand{\@subject}{}
\newcommand{\subject}[1]{\renewcommand{\@subject}{\bilingual{Subject: }{Objet : } #1}}

% According to the document "Guide des normes graphiques", the logo, 
% address and the footer should be 0.5in from the left. If we set 
% the text left margin to 0.5in, it will look strange. So, we adjust the 
% left and right margins to 0.8in to look more pleasing to the eye. 
\geometry{ 
    paper=letterpaper, % North America does not seem to have embraced ISO A4, we always use letter
    hmargin=0.8in,
    bottom=0.25in+10pt+15pt, 
    top=0.8in,
    hcentering=true
}

% According to ETS guidelines, content should use the Delta Jaeger font family
\setmainfont{delta-light}[
    Path = fonts/, 
    BoldFont = delta-book, 
    ItalicFont = delta-light-italic,
    BoldItalicFont = delta-book-italic,
    Ligatures=TeX
]

% Bar colour according to the document "Guide des normes graphiques"
\definecolor{red-bar}{rgb}{0.9372, 0.2431, 0.2705}
\parindent 0pt 

% Add a little bit of space after the logo and address
\apptocmd{\letter}{\vspace*{1.5in}}{}{}

% The following lines insert the logo and address when the letter starts.
\pretocmd{\letter}{%
  \begin{textblock*}{4in}(0.5in, 0.375in)
  \usebox{\etshead}
  \end{textblock*}

  \begin{textblock*}{4in}(0.5in, 1.375in+0.125in)
    \begin{minipage}[t]{\linewidth}
        \parbox[t]{3.0in}{\raggedright{
        \setstretch{1.3}\fontsize{7}{7}\selectfont \textbf{École de technologie supérieure}\\
        1100, rue Notre-Dame Ouest\\
        Montréal (Québec) Canada H3C 1K3\\
        \bilingual{Phone:}{Téléphone :} \ETSphone\\
        \medskip
        \textbf{\ETSdepartment}
        } % end raggedright
    } % end parbox 
    \end{minipage}
  \end{textblock*}
}{}{}

\newsavebox{\etshead}
\newsavebox{\etsfoot}
\sbox{\etshead}{
    \parbox[t]{4.0in}{\raggedright
    \bilingual
        {\includegraphics[width=1.5in]{logos/ets_red_en}}
        {\includegraphics[width=1.5in]{logos/ets_red_fr}}
    }
}

% Set up the footer text. 
\sbox{\etsfoot}{
\hspace{-0.3in}
    \begin{minipage}{\textwidth}
    \color{red-bar}{\hrule width 3.6in height 0.75pt} 
    \smallskip\color{black}{
        {\fontsize{10}{10}\selectfont 
        \bilingual
            {ÉTS is a constituent establishment of the Université du Québec}
            {L'ÉTS est une constituante du réseau de l'Université du Québec}
        } % end fontsize block
    } % end color black block
    \end{minipage}
}

\newcommand{\pagenumber}{
    \ifthenelse{\equal{\thepage}{}}{}{
        {\fontsize{10}{10}\selectfont \thepage/\pageref{LastPage}}
    }
}
% Redefine the footers
\renewcommand{\ps@firstpage}{
    \renewcommand{\@oddhead}{}
    \renewcommand{\@oddfoot}{\usebox{\etsfoot}\pagenumber}
    \renewcommand{\@evenhead}{}
    \renewcommand{\@evenfoot}{}
}

\renewcommand{\ps@empty}{
    \renewcommand{\@oddhead}{}
    \renewcommand{\@oddfoot}{\usebox{\etsfoot}\pagenumber}
    \renewcommand{\@evenhead}{}
    \renewcommand{\@evenfoot}{\usebox{\etsfoot}\pagenumber}
}

\providecommand{\@evenhead}{}
\providecommand{\@oddhead}{}
\providecommand{\@evenfoot}{}
\providecommand{\@oddfoot}{}

% We must include the subject in the opening.
\renewcommand{\opening}[1]{\thispagestyle{firstpage}%
    \@date\par
    {\raggedright \toname \\ \toaddress \par}%
    \vspace{1\parskip}
    \ifthenelse{\equal{\@subject}{}}{}{\textbf{\@subject}\par}
    \vspace{1\parskip}%
    #1\par\nobreak
}

% We force closing to the left.
\renewcommand{\closing}[1]{\par\nobreak\vspace{\parskip}%
    \stopbreaks
    \noindent
    \parbox{1.\textwidth}{\raggedright
    \ignorespaces #1\\[4\medskipamount]%
    \ifx\@empty\fromsig
        \fromname
    \else \fromsig\raggedright 
    \fi\strut
    \par
    \ifx\@empty\fromaddress\else
    \fromaddress
    \fi
    }
}

\parskip 10pt plus2pt minus2pt
\pagestyle{empty} 