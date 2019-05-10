<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
  method="text"
  indent="no"
  omit-xml-declaration="yes"
/>

<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="addr_line"/>

<xsl:template match="/">
  \font\bigbigbf = cmb10 scaled \magstep 2
  \font\bigbf = cmb10 scaled \magstep 1
  \nopagenumbers
  \overfullrule = 0 pt
  <xsl:apply-templates/>
  \bye
</xsl:template>

<!-- header -->

<xsl:template match="header">
  <xsl:apply-templates/>
  \bigskip
</xsl:template>

<xsl:template match="name">
  <xsl:variable name="name">
    <xsl:apply-templates select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="surname"/>
  </xsl:variable>
  \headline={\ifnum\pageno=1\else{\rm\hfill <xsl:value-of select="normalize-space($name)"/>, Page \folio\voffset=2\normalbaselineskip}\fi}
  \centerline{\bigbigbf <xsl:value-of select="normalize-space($name)"/>}
  \medskip
</xsl:template>

<xsl:template match="addr_line">
  <xsl:variable name="text">
    <xsl:call-template name="escape">
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
  </xsl:variable>
  \centerline{<xsl:value-of select="normalize-space($text)"/>}
  <xsl:if test="position() = last()">
    \medskip
  </xsl:if>
</xsl:template>

<xsl:template match="phone | email | website">
  <xsl:variable name="text">
    <xsl:call-template name="escape">
      <xsl:with-param name="text" select="." />
    </xsl:call-template>
  </xsl:variable>
  \centerline{<xsl:value-of select="normalize-space($text)"/>}
</xsl:template>

<!-- objective -->

<xsl:template match="objective">
  {\parindent = 0pt \bigbigbf Objective}
  \medskip
  {\parindent = 0pt
  <xsl:apply-templates/>
  }
  \bigskip
</xsl:template>

<!-- skills -->

<xsl:template match="skills">
  {\parindent = 0pt \bigbigbf Skills}
  \medskip
  <xsl:apply-templates/>
  \bigskip
</xsl:template>

<xsl:template match="skill">
  <xsl:variable name="title">
    <xsl:apply-templates select="title"/>
  </xsl:variable>
  <xsl:variable name="description">
    <xsl:apply-templates select="description"/>
  </xsl:variable>
  \item{$\bullet$} <xsl:value-of select="normalize-space(concat($title, ': ', $description))"/>
</xsl:template>

<!-- employment -->

<xsl:template match="employment">
  {\parindent = 0pt \bigbigbf Employment}
  \medskip
  <xsl:apply-templates/>
  \bigskip
</xsl:template>

<xsl:template match="job">
<!--   {\filbreak -->
  \line{{\bigbf <xsl:apply-templates select="title"/>} \hfil <xsl:apply-templates select="period"/>}
  {\parindent = 0pt <xsl:apply-templates select="employer"/>}
  <xsl:apply-templates select="description"/>
<!--   } -->
  <xsl:if test="position() != last()">
    \medskip
  </xsl:if>
</xsl:template>

<!-- education -->

<xsl:template match="academics">
  {\parindent = 0pt \bigbigbf Education}
  \medskip
  <xsl:apply-templates/>
  \bigskip
</xsl:template>

<xsl:template match="training">
  {\parindent = 0pt \bigbf Training}
  <xsl:apply-templates/>
  \medskip
</xsl:template>

<xsl:template match="class">
  <xsl:variable name="class">
    <xsl:apply-templates/>
  </xsl:variable>
  \item{$\bullet$} <xsl:value-of select="normalize-space($class)"/>
</xsl:template>

<xsl:template match="certifications">
  {\parindent = 0pt \bigbf Certifications}
  <xsl:apply-templates/>
  \medskip
</xsl:template>

<xsl:template match="certification">
  <xsl:variable name="certification">
    <xsl:apply-templates/>
  </xsl:variable>
  \item{$\bullet$} <xsl:value-of select="normalize-space($certification)"/>
</xsl:template>

<xsl:template match="degree">
  \line{{\bigbf <xsl:apply-templates select="level"/> <xsl:apply-templates select="subject"/>} \hfil <xsl:apply-templates select="date | period"/>}
  {\parindent = 0pt <xsl:apply-templates select="institution"/>}
  <xsl:apply-templates select="coursework"/>
    \medskip
</xsl:template>

<xsl:template match="level">
  <xsl:value-of select="normalize-space(.)"/>
  <xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="subject | institution">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<!-- keywords -->

<xsl:template match="keywords"/>

<!-- escape special tex characters -->

<xsl:template name="escape">
  <xsl:param name="text"/>
  <xsl:variable name="char" select="substring($text, 1, 1)"/>

  <!-- before -->

  <xsl:if test="$char = '\'">
    <xsl:text>$</xsl:text>
  </xsl:if>

  <xsl:if test="$char = '{' or $char = '}'">
    <xsl:text>$\</xsl:text>
  </xsl:if>

  <xsl:if test="$char = '%' or $char = '&amp;' or $char = '~' or $char = '$'
                or $char = '^' or $char = '_' or $char = '#'">
    <xsl:text>\</xsl:text>
  </xsl:if>

  <!-- the char -->

  <xsl:value-of select="$char"/>

  <!-- after -->

  <xsl:if test="$char = '\'">
    <xsl:text>backslash$</xsl:text>
  </xsl:if>

  <xsl:if test="$char = '{' or $char = '}'">
    <xsl:text>$</xsl:text>
  </xsl:if>

  <xsl:if test="$char = '~' or $char = '^' or $char = '_'">
    <xsl:text>{}</xsl:text>
  </xsl:if>

  <!-- recurse -->

  <xsl:if test="string-length($text) > 1">
    <xsl:call-template name="escape">
      <xsl:with-param name="text" select="substring($text, 2)"/>
    </xsl:call-template>
  </xsl:if>

</xsl:template>

<xsl:template match="text()">
  <xsl:call-template name="escape">
    <xsl:with-param name="text" select="." />
  </xsl:call-template>
</xsl:template>

<!-- other -->

<xsl:template match="item">
  <xsl:variable name="item">
    <xsl:apply-templates/>
  </xsl:variable>
  \item{$\bullet$} <xsl:value-of select="normalize-space($item)"/>
</xsl:template>

<xsl:template match="period">
  <xsl:apply-templates select="from"/>
  <xsl:text> to </xsl:text>
  <xsl:apply-templates select="to"/>
</xsl:template>

<xsl:template match="date">
  <xsl:apply-templates select="month"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="year"/>
</xsl:template>

<xsl:template match="present">
  <xsl:text>the present</xsl:text>
</xsl:template>

<!--
<xsl:template match="url">
  <xsl:value-of select="."/>
  <xsl:text> $&lt;$</xsl:text><xsl:apply-templates select="@href"/><xsl:text>$>$</xsl:text>
</xsl:template>
-->

</xsl:stylesheet>
