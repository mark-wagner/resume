<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
  method="html"
  indent="yes"
  omit-xml-declaration="yes"
  doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
/>

<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="addr_line"/>

<xsl:template match="/">
  <html>
    <head>
      <style type="text/css">
        <xsl:comment>    
          BODY { background-color: white; color: black }
        </xsl:comment>    
      </style>

      <xsl:apply-templates select="resume/keywords" mode="head"/>
      <title><xsl:apply-templates select="resume/header/name"/>'s Resume</title>
    </head>
    <body>
      <xsl:apply-templates select="resume"/>

      <!--

      <p align="right">
        <a href="http://validator.w3.org/check?uri=http%3A%2F%2Fwww.lanfear.net%2F%7Emark%2Fmw.html;doctype=Inline">
        <img border="0" src="http://www.w3.org/Icons/valid-html401"
          alt="Valid HTML 4.01!" height="31" width="88"/></a>
        <a href="http://jigsaw.w3.org/css-validator/validator?uri=http://www.lanfear.net/~mark/mw.html">
          <img border="0" width="88" height="31"
          src="http://jigsaw.w3.org/css-validator/images/vcss" 
          alt="Valid CSS!"/>
        </a>
      </p>

      -->

    </body>
  </html>
</xsl:template>

<!-- keywords -->

<xsl:template match="keywords"/>

<xsl:template match="keywords" mode="head">
  <meta name="keywords">
    <xsl:attribute name="content">
      <xsl:apply-templates select="keyword"/>
    </xsl:attribute>
  </meta>
</xsl:template>

<xsl:template match="keyword">
  <xsl:value-of select="."/>
  <xsl:if test="position() != last()">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<!-- header -->

<xsl:template match="header">
  <div align="center">
    <h1><xsl:apply-templates select="name"/></h1>
    <xsl:apply-templates select="address"/>
    <xsl:apply-templates select="contact"/>
  </div>
</xsl:template>

<xsl:template match="name">
  <xsl:apply-templates select="firstname"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="surname"/>
</xsl:template>

<xsl:template match="addr_line">
  <xsl:value-of select="."/>
  <br/>
  <xsl:if test="position() = last()">
    <br/>
  </xsl:if>
</xsl:template>

<xsl:template match="phone">
  <xsl:value-of select="."/>
  <br/>
</xsl:template>

<xsl:template match="email">
  <a>
    <xsl:attribute name="href">
      <xsl:text>mailto:</xsl:text><xsl:value-of select="."/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </a>
  <br/>
</xsl:template>

<xsl:template match="website">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="."/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </a>
  <br/>
</xsl:template>
  
<!-- objective -->

<xsl:template match="objective">
  <h2>Objective</h2>
  <p><xsl:apply-templates/></p>
</xsl:template>

<!-- skills -->

<xsl:template match="skills">
  <h2>Skills</h2>
  <ul>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="skill">
  <li><xsl:apply-templates/></li>
</xsl:template>

<xsl:template match="skill/title">
  <strong><xsl:value-of select="."/></strong><xsl:text>: </xsl:text>
</xsl:template>

<!-- employment -->

<xsl:template match="employment">
  <h2>Employment</h2>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="job">
  <table width="100%" summary="Job">
    <tr>
      <td width="50%"><strong><xsl:apply-templates select="title"/></strong></td>
      <td width="50%" align="right"><xsl:apply-templates select="period"/></td>
    </tr>
    <tr>
      <td colspan="2"><xsl:apply-templates select="employer"/></td>
    </tr>
    <xsl:if test="count(description) > 0">
    <tr>
      <td colspan="2">
        <ul>
          <xsl:apply-templates select="description"/>
        </ul>
      </td>
    </tr>
    </xsl:if>
  </table>
  <br/>
</xsl:template>

<!-- academics -->

<xsl:template match="academics">
  <h2>Education</h2>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="training">
  <p><strong>Training</strong></p>
  <ul>
  <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="class">
  <li><xsl:apply-templates/></li>
</xsl:template>

<xsl:template match="certifications">
  <p><strong>Certifications</strong></p>
  <ul>
  <xsl:apply-templates/>
  </ul>
</xsl:template>

<xsl:template match="certification">
  <li><xsl:apply-templates/></li>
</xsl:template>

<xsl:template match="degree">
  <table width="100%" summary="Degree">
    <tr>
      <td width="50%">
        <strong>
          <xsl:apply-templates select="level"/>
          <xsl:apply-templates select="subject"/>
        </strong>
      </td>
      <td width="50%" align="right">
        <xsl:apply-templates select="date | period"/>
      </td>
    </tr>
    <tr>
      <td colspan="2"><xsl:apply-templates select="institution"/></td>
    </tr>
    <xsl:apply-templates select="coursework"/>
  </table>
  <br/>
</xsl:template>

<xsl:template match="level">
  <xsl:value-of select="normalize-space(.)"/>
  <xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="coursework">
  <tr>
    <td colspan="2">
      <ul>
        <xsl:apply-templates/>
      </ul>
    </td>
  </tr>
</xsl:template>

<!-- other -->

<xsl:template match="item">
  <li><xsl:apply-templates/></li>
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

<xsl:template match="url">
  <a>
    <xsl:attribute name="href">
      <xsl:apply-templates select="@href"/>
    </xsl:attribute>
    <xsl:value-of select="."/>
  </a>
</xsl:template>


</xsl:stylesheet>
