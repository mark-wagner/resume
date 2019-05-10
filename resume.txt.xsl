<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output
  method="text"
  omit-xml-declaration="yes"
  indent="no"
/>

<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="addr_line"/>

<xsl:param name="PAGE_WIDTH">70</xsl:param>
<xsl:param name="BULLET">*</xsl:param>

<!--

     utility templates

-->

<!-- newline -->

<xsl:template name="nl">
<xsl:text>
</xsl:text>
</xsl:template>

<!-- space -->

<xsl:template name="space">
  <xsl:param name="n" select="0"/>
  <xsl:if test="$n > 0">
    <xsl:text> </xsl:text>
    <xsl:call-template name="space">
      <xsl:with-param name="n" select="$n - 1" />
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- indent -->

<xsl:template name="indent">
  <xsl:param name="indent" select="2"/>
  <xsl:param name="leader" select="string('*')"/>
  <xsl:param name="line" select="0"/>
  <xsl:choose>
    <xsl:when test="$line = 0">
      <xsl:call-template name="space">
        <xsl:with-param name="n" select="$indent - 2"/>
      </xsl:call-template>
    <xsl:value-of select="concat($leader, ' ')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="space">
        <xsl:with-param name="n" select="$indent"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- wrap -->

<!-- FIXME: too long, convoluted -->

<xsl:template name="wrap">
  <xsl:param name="text"/>
  <xsl:param name="width" select="$PAGE_WIDTH"/>
  <xsl:param name="pos" select="0"/>
  <xsl:param name="indent" select="0"/>
  <xsl:param name="leader" select="$BULLET"/>
  <xsl:param name="line" select="0"/>

  <!-- indent? -->
  <xsl:choose>

    <!-- indent -->
    <xsl:when test="$indent > 0 and $pos = 0">

      <xsl:call-template name="indent">
        <xsl:with-param name="indent" select="$indent"/>
        <xsl:with-param name="leader" select="$leader"/>
        <xsl:with-param name="line" select="$line"/>
      </xsl:call-template>

      <xsl:call-template name="wrap">
        <xsl:with-param name="text" select="$text"/>
        <xsl:with-param name="pos" select="$indent"/>
        <xsl:with-param name="indent" select="$indent"/>
        <xsl:with-param name="line" select="$line"/>
      </xsl:call-template>

    </xsl:when>

    <!-- no indent; try to put a word on the line -->
    <xsl:otherwise>

      <!-- how many words? -->
      <xsl:choose>

        <!-- more than one word -->
        <xsl:when test="contains($text,' ')">
          <xsl:variable name="word" select="substring-before($text,' ')"/>

          <!-- can word fit on line? -->
          <xsl:choose>

            <!-- if word > width -->
            <xsl:when test="(1 + string-length($word)) &gt; $width">

              <xsl:call-template name="nl"/>
              <xsl:value-of select="$word"/>
              <xsl:call-template name="nl"/>
              <xsl:call-template name="wrap">
                <xsl:with-param name="text" select="substring-after($text,' ')"/>
                <xsl:with-param name="pos" select="0"/>
                <xsl:with-param name="indent" select="$indent"/>
                <xsl:with-param name="line" select="$line + 1"/>
              </xsl:call-template>

            </xsl:when>

            <!-- if a space + word would overflow line -->
            <xsl:when test="(1 + $pos + string-length($word)) &gt; $width">

              <xsl:call-template name="nl"/>
              <xsl:call-template name="wrap">
                <xsl:with-param name="text" select="$text"/>
                <xsl:with-param name="pos" select="0"/>
                <xsl:with-param name="indent" select="$indent"/>
                <xsl:with-param name="line" select="$line + 1"/>
              </xsl:call-template>

            </xsl:when>

            <!-- line has room for space + word -->
            <xsl:otherwise>

              <!-- are we at the bol?  -->
              <xsl:choose>

                <!-- no space at bol -->
                <xsl:when test="$pos = $indent">

                  <xsl:value-of select="$word"/>
                  <xsl:call-template name="wrap">
                    <xsl:with-param name="text" select="substring-after($text,' ')"/>
                    <xsl:with-param name="pos" select="$pos + string-length($word)"/>
                    <xsl:with-param name="indent" select="$indent"/>
                    <xsl:with-param name="line" select="$line"/>
                  </xsl:call-template>

                </xsl:when>

                <!-- not bol:space + word -->
                <xsl:otherwise>

                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$word"/>
                  <xsl:call-template name="wrap">
                    <xsl:with-param name="text" select="substring-after($text,' ')"/>
                    <xsl:with-param name="pos" select="$pos + string-length($word) + 1"/>
                    <xsl:with-param name="indent" select="$indent"/>
                    <xsl:with-param name="line" select="$line"/>
                  </xsl:call-template>

                 </xsl:otherwise>

              </xsl:choose>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:when>

        <!-- only one word left -->
        <xsl:otherwise>

          <xsl:choose>

            <!-- if a space + text would overflow line -->
            <xsl:when test="(1 + $pos + string-length($text)) &gt; $width">

              <xsl:call-template name="nl"/>

              <!-- indent? -->
              <xsl:if test="$indent > 0">

                <xsl:call-template name="indent">
                  <xsl:with-param name="indent" select="$indent"/>
                  <xsl:with-param name="line" select="$line + 1"/>
                </xsl:call-template>

              </xsl:if>

              <xsl:value-of select="$text"/>
              <xsl:call-template name="nl"/>

            </xsl:when>

            <!-- line has room for space + text -->
            <xsl:otherwise>

              <!-- space? -->
              <xsl:if test="$pos != $indent">

                <xsl:text> </xsl:text>

              </xsl:if>

              <xsl:value-of select="$text"/>
              <xsl:call-template name="nl"/>

            </xsl:otherwise>

          </xsl:choose>

        </xsl:otherwise>

      </xsl:choose>

    </xsl:otherwise>

  </xsl:choose>

</xsl:template>

<!-- center -->

<xsl:template name="center">
  <xsl:param name="width" select="$PAGE_WIDTH"/>
  <xsl:param name="text"/>
  <xsl:call-template name="space">
    <xsl:with-param name="n" select="($width - string-length($text)) div 2" />
  </xsl:call-template>
  <xsl:value-of select="$text"/>
  <xsl:call-template name="nl"/>
</xsl:template>

<!--

     header

-->

<!--
     name
-->

<xsl:template match="name">
  <xsl:variable name="name">
    <xsl:apply-templates select="firstname"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="surname"/>
  </xsl:variable>
  <xsl:call-template name="center">
    <xsl:with-param name="text" select="normalize-space($name)"/>
  </xsl:call-template>
  <xsl:call-template name="nl"/>
</xsl:template>

<!--
     address
-->

<xsl:template match="address">
  <xsl:apply-templates/>
  <xsl:call-template name="nl"/>
</xsl:template>

<!--
     addr_line
-->

<xsl:template match="addr_line">
  <xsl:call-template name="center">
    <xsl:with-param name="text" select="normalize-space(.)"/>
  </xsl:call-template>
</xsl:template>

<!--
     contact
-->

<xsl:template match="contact">
  <xsl:apply-templates select="phone"/>
  <xsl:apply-templates select="email"/>
  <xsl:apply-templates select="website"/>
  <xsl:call-template name="nl"/>
</xsl:template>

<xsl:template match="phone | email | website">
  <xsl:call-template name="center">
    <xsl:with-param name="text" select="normalize-space(.)"/>
  </xsl:call-template>
</xsl:template>

<!--

     objective

-->

<xsl:template match="objective">
  <xsl:text>Objective</xsl:text>
  <xsl:call-template name="nl"/>
  <xsl:call-template name="nl"/>
  <xsl:variable name="text">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:call-template name="wrap">
    <xsl:with-param name="text">
      <xsl:value-of select="normalize-space($text)"/>
    </xsl:with-param>
    <xsl:with-param name="indent" select="0"/>
  </xsl:call-template>
  <xsl:call-template name="nl"/>
</xsl:template>

<!--

     skills

-->

<xsl:template match="skills">
  <xsl:text>Skills</xsl:text>
  <xsl:call-template name="nl"/>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates/>
  <xsl:call-template name="nl"/>
</xsl:template>

<xsl:template match="skill">
  <xsl:variable name="title">
    <xsl:apply-templates select="title"/>
  </xsl:variable>
  <xsl:variable name="description">
    <xsl:apply-templates select="description"/>
  </xsl:variable>
  <xsl:call-template name="wrap">
    <xsl:with-param name="text">
      <xsl:value-of select="normalize-space(concat($title, ': ', $description))"/>
    </xsl:with-param>
    <xsl:with-param name="indent" select="4"/>
  </xsl:call-template>
</xsl:template>

<!--

     employment

-->

<xsl:template match="employment">
  <xsl:text>Employment</xsl:text>
  <xsl:call-template name="nl"/>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="job">
  <xsl:apply-templates select="title"/>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates select="employer"/>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates select="period"/>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates select="description"/>
  <xsl:call-template name="nl"/>
</xsl:template>

<!--

     academics

-->

<xsl:template match="academics">
  <xsl:text>Education</xsl:text>
  <xsl:call-template name="nl"/>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates/>
  <xsl:call-template name="nl"/>
</xsl:template>

<!--
     training
-->

<xsl:template match="training">
  <xsl:text>Training</xsl:text>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates/>
  <xsl:call-template name="nl"/>
</xsl:template>

<xsl:template match="class">
  <xsl:variable name="text">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:call-template name="wrap">
    <xsl:with-param name="text">
      <xsl:value-of select="normalize-space($text)"/>
    </xsl:with-param>
    <xsl:with-param name="indent" select="4"/>
  </xsl:call-template>
</xsl:template>

<!--
     certifications
-->

<xsl:template match="certifications">
  <xsl:text>Certifications</xsl:text>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates/>
  <xsl:call-template name="nl"/>
</xsl:template>

<xsl:template match="certification">
  <xsl:variable name="text">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:call-template name="wrap">
    <xsl:with-param name="text">
      <xsl:value-of select="normalize-space($text)"/>
    </xsl:with-param>
    <xsl:with-param name="indent" select="4"/>
  </xsl:call-template>
</xsl:template>

<!--
     degrees
-->

<xsl:template match="degree">
  <xsl:apply-templates select="level"/>
  <xsl:apply-templates select="subject"/>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates select="institution"/>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates select="date | period"/>
  <xsl:call-template name="nl"/>
  <xsl:apply-templates select="coursework"/>
  <xsl:call-template name="nl"/>
</xsl:template>

<xsl:template match="level">
  <xsl:value-of select="normalize-space(.)"/>
  <xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="subject | institution">
  <xsl:value-of select="normalize-space(.)"/>
</xsl:template>

<!--

     other

-->

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

<xsl:template match="item">
  <xsl:variable name="text">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:call-template name="wrap">
    <xsl:with-param name="text">
      <xsl:value-of select="normalize-space($text)"/>
    </xsl:with-param>
    <xsl:with-param name="indent" select="4"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="url">
  <xsl:value-of select="."/>
  <xsl:text> &lt;</xsl:text><xsl:apply-templates select="@href"/><xsl:text>></xsl:text>
</xsl:template>

<xsl:template match="keywords"/>

</xsl:stylesheet>
