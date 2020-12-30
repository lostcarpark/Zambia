<?xml version="1.0" encoding="UTF-8" ?>
<!--
	Created by Syd Weinstein on 2020-12-20;
	Copyright (c) 2020 Peter Olszowka. All rights reserved. See copyright document for more details.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output encoding="UTF-8" indent="yes" method="html" />
  <xsl:param name="buttons" select="''"/>
  <xsl:param name="control" select="''"/>
  <xsl:param name="controliv" select="''"/>
  <xsl:param name="UpdateMessage" select="''"/>
  <xsl:template match="/">
    <xsl:if test="$UpdateMessage != ''">
      <div id="message" class="alert alert-success mt-4">
        <xsl:value-of select="$UpdateMessage" disable-output-escaping="yes"/>
      </div>
    </xsl:if>
    <form name="partsurveyform" method="POST" action="PartSurvey.php"  onsubmit="return UpdateSurvey();">
      <input type="hidden" id="PostCheck" name="PostCheck" value="POST"/>
      <input type="hidden" id="control" name="control" value="{$control}" />
      <input type="hidden" id="controliv" name="controliv" value="{$controliv}" />
      <xsl:call-template name="questions">
        <xsl:with-param name="buttons" select="$buttons" />
      </xsl:call-template>
      <xsl:if test="$buttons = 'refresh'">
        <div id="preview-buttons">
          <div class="row mt-4">
            <div class="col col-auto">
              <button class="btn btn-info" id="previewbtn" name="previewbtn" type="button" value="preview" onclick="window.location.reload();">Refresh Preview</button>
            </div>
          </div>
        </div>
      </xsl:if>
      <xsl:if test="$buttons = 'save'">
        <div id="submit-buttons">
          <div class="row mt-4">
            <div class="col col-auto">
              <button class="btn btn-primary" id="submitbtn" name="submitbbtn" type="submit" value="submit">Save Survey</button>
            </div>
          </div>
        </div>
      </xsl:if>
      <xsl:if test="$buttons = 'update'">
        <div id="submit-buttons">
          <div class="row mt-4">
            <div class="col col-auto">
              <button class="btn btn-primary" id="submitbtn" name="submitbbtn" type="submit" value="submit">Update Survey</button>
            </div>
          </div>
        </div>
      </xsl:if>
    </form>
  </xsl:template>
  <xsl:template name="questions">
    <xsl:param name="buttons" select="''"/>
    <xsl:for-each select="/doc/query[@queryName='questions']/row">
      <xsl:choose>
        <xsl:when test="@typename = 'heading'">
          <div>
            <xsl:attribute name="id">
              <xsl:value-of select="translate(@shortname, ' ', '_')"/>
            </xsl:attribute>
            <div class="row mt-4">
              <div class="col col-12">
                <xsl:value-of select="@hover" disable-output-escaping="yes"/>  
              </div>
            </div>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div>
            <xsl:attribute name="id">
              <xsl:value-of select="translate(@shortname, ' ', '_')"/>
            </xsl:attribute>
            <div class="row mt-4">
              <div class="col col-3">
                <span>
                  <xsl:attribute name="id">
                    <xsl:value-of select="translate(@shortname, ' ', '_')"/>
                    <xsl:text>-prompt</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:value-of select="@hover"/>
                  </xsl:attribute>
                  <xsl:attribute name="data-toggle">
                    <xsl:text>tooltip</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="data-placement">
                    <xsl:text>right</xsl:text>
                  </xsl:attribute>
                  <xsl:attribute name="data-html">
                    <xsl:text>true</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="@prompt"/>
                  <xsl:if test="@required = 1">
                    <span style="color: #990012;">
                      <xsl:text disable-output-escaping="yes">*</xsl:text>
                    </span>
                  </xsl:if>
                </span>
              </div>
              <xsl:choose>
                <xsl:when test="@display_only = 1">
                  <div class="col col-9">
                    <xsl:value-of select="@answer" disable-output-escaping="yes"/>
                    <xsl:if test="@other_text != ''">
                      <xsl:text> &#160;Other: </xsl:text>
                      <xsl:value-of select="@othertext"/>
                    </xsl:if>
                    <xsl:if test="$buttons='refresh'">
                      <xsl:text>Display Only set will show answer to question </xsl:text>
                      <xsl:value-of select="@questionid"/>
                      <xsl:text>: </xsl:text>
                      <xsl:value-of select="@shortname"/>    
                    </xsl:if>
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="@typename = 'openend'">
                      <xsl:call-template name="openend">
                        <xsl:with-param name="questionid" select="@questionid" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@typename = 'text' or @typename = 'html-text'">
                      <xsl:call-template name="text">
                        <xsl:with-param name="questionid" select="@questionid" />
                        <xsl:with-param name="typename" select="@typename" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@typename = 'number'">
                      <xsl:call-template name="number">
                        <xsl:with-param name="questionid" select="@questionid" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@typename = 'numberselect' or @typename = 'monthnum' or
                  @typename = 'monthabv' or @typename = 'states' or @typename = 'country' or 
                  @typename = 'single-pulldown' or @typename = 'multi-select list'">
                      <xsl:call-template name="selectlist">
                        <xsl:with-param name="questionid" select="@questionid" />
                        <xsl:with-param name="answer" select="@answer" />
                        <xsl:with-param name="answermulti" select="concat(',', @answer, ',')" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@typename = 'monthyear'">
                      <xsl:call-template name="monthyear">
                        <xsl:with-param name="questionid" select="@questionid" />
                        <xsl:with-param name="shortname" select="@shortname" />
                        <xsl:with-param name="answer" select="@answer" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@typename = 'single-radio'">
                      <xsl:call-template name="radio">
                        <xsl:with-param name="questionid" select="@questionid" />
                        <xsl:with-param name="shortname" select="@shortname" />
                        <xsl:with-param name="answer" select="@answer" />
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@typename = 'multi-checkbox list'">
                      <xsl:call-template name="selectcheckbox">
                        <xsl:with-param name="questionid" select="@questionid" />
                        <xsl:with-param name="shortname" select="@shortname" />
                        <xsl:with-param name="answer" select="concat(',', @answer, ',')"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="@typename = 'multi-display'">
                      <xsl:call-template name="multi-display">
                        <xsl:with-param name="questionid" select="@questionid" />
                        <xsl:with-param name="shortname" select="@shortname" />
                        <xsl:with-param name="answer" select="@answer" />
                        <xsl:with-param name="answermulti" select="concat(',', @answer, ',')" />
                      </xsl:call-template>
                    </xsl:when>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </div>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name="openend">
    <xsl:param name="questionid" select="''"/>
    <div class="col col-9">
      <xsl:for-each select="/doc/query[@queryName='questions']/row[@questionid=$questionid]">
        <input type="text">
          <xsl:attribute name="id">
            <xsl:value-of select="translate(@shortname, ' ', '_')"/>
            <xsl:text>-input</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="translate(@shortname, ' ', '_')"/>
          </xsl:attribute>
          <xsl:attribute name="maxlength">
            <xsl:value-of select="@max_value"/>
          </xsl:attribute>
          <xsl:attribute name="size">
            <xsl:value-of select="@size"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="@answer"/>
          </xsl:attribute>
        </input>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template name="text">
    <xsl:param name="questionid" select="''"/>
    <xsl:param name="typename" select="''"/>
    <div class="col col-9">
      <xsl:for-each select="/doc/query[@queryName='questions']/row[@questionid=$questionid]">
        <textarea>
          <xsl:attribute name="id">
            <xsl:value-of select="translate(@shortname, ' ', '_')"/>
            <xsl:text>-input</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="translate(@shortname, ' ', '_')"/>
          </xsl:attribute>
          <xsl:attribute name="maxlength">
            <xsl:value-of select="@max_value"/>
          </xsl:attribute>
          <xsl:attribute name="rows">
            <xsl:value-of select="@rows"/>
          </xsl:attribute>
          <xsl:attribute name="cols">
            <xsl:value-of select="@size"/>
          </xsl:attribute>
          <xsl:if test="$typename = 'html-text'">
            <xsl:attribute name="data-mce">
              <xsl:text>yes</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="@answer"/>
        </textarea>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template name="number">
    <xsl:param name="questionid" select="''"/>
    <div class="col col-9">
      <xsl:for-each select="/doc/query[@queryName='questions']/row[@questionid=$questionid]">
        <input type="number">
          <xsl:attribute name="id">
            <xsl:value-of select="translate(@shortname, ' ', '_')"/>
            <xsl:text>-input</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="translate(@shortname, ' ', '_')"/>
          </xsl:attribute>
          <xsl:attribute name="min">
            <xsl:value-of select="@min_value"/>
          </xsl:attribute>
          <xsl:attribute name="max">
            <xsl:value-of select="@max_value"/>
          </xsl:attribute>
          <xsl:attribute name="value">
            <xsl:value-of select="@answer"/>
          </xsl:attribute>
        </input>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template name="selectlist">
    <xsl:param name="questionid" select="''"/>
    <xsl:param name="answer" select="''"/>
    <xsl:param name="answermulti" select="''"/>
    <div class="col col-9">
      <xsl:for-each select="/doc/query[@queryName='questions']/row[@questionid=$questionid]">
        <select>
          <xsl:attribute name="id">
            <xsl:value-of select="translate(@shortname, ' ', '_')"/>
          </xsl:attribute>
          <xsl:attribute name="name">
            <xsl:value-of select="translate(@shortname, ' ', '_')"/>
            <xsl:if test="@typename = 'multi-select list'">
              <xsl:text>[]</xsl:text>
            </xsl:if>
          </xsl:attribute>
          <xsl:if test="@typename = 'multi-select list'">
            <xsl:attribute name="style">
              <xsl:text>height: 100px;</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="multiple"/>
          </xsl:if>     
          <xsl:for-each select="/doc/query[@queryName='options']/row[@questionid=$questionid]">
            <option value="{@value}">
              <xsl:if test="@optionhover != ''">
                <xsl:attribute name="title">
                  <xsl:value-of select="@optionhover"/>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="(@value=$answer) or contains($answermulti, concat(',', @value, ','))">
                <xsl:attribute name="selected"/>
              </xsl:if>
              <xsl:value-of select="@optionshort"/>
            </option>
          </xsl:for-each>
        </select>
      </xsl:for-each>
    </div>
  </xsl:template>
  <xsl:template name="monthyear">
    <xsl:param name="questionid" select="''"/>
    <xsl:param name="shortname" select="''"/>
    <xsl:param name="answer" select="''"/>
    <div class="col col-auto">
      <select>
        <xsl:attribute name="id">
          <xsl:value-of select="translate($shortname, ' ', '_')"/>
          <xsl:text>_month</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="translate($shortname, ' ', '_')"/>
          <xsl:text>[]</xsl:text>
        </xsl:attribute>
        <xsl:for-each select="/doc/query[@queryName='options']/row[@questionid=$questionid]">
          <option value="{@value}">
            <xsl:attribute name="title">
              <xsl:value-of select="@optionhover"/>
            </xsl:attribute>
            <xsl:if test="contains($answer, @value)">
              <xsl:attribute name="selected"/>
            </xsl:if>
            <xsl:value-of select="@optionshort"/>
          </option>
        </xsl:for-each>
      </select>
    </div>
    <div class="col col-auto">
      <select>
        <xsl:attribute name="id">
          <xsl:value-of select="translate($shortname, ' ', '_')"/>
          <xsl:text>-year</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="name">
          <xsl:value-of select="translate($shortname, ' ', '_')"/>
          <xsl:text>[]</xsl:text>
        </xsl:attribute>
        <xsl:for-each select="/doc/query[@queryName='years']/row[@questionid=$questionid]">
          <option value="{@value}">
             <xsl:if test="contains($answer, @value)">
              <xsl:attribute name="selected"/>
            </xsl:if>
            <xsl:value-of select="@value"/>
          </option>
        </xsl:for-each>
      </select>
    </div>
  </xsl:template>
  <xsl:template name="radio">
    <xsl:param name="questionid" select="''"/>
    <xsl:param name="shortname" select="''"/>
    <xsl:param name="answer" select="''"/>
    <div class="col col-9">
      <xsl:for-each select="/doc/query[@queryName='options']/row[@questionid=$questionid]">
        <div class="form-check-inline">
          <input class="form-check-input" type="radio">
            <xsl:attribute name="id">
              <xsl:value-of select="translate($shortname, ' ', '_')"/>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="translate(@value, ' ', '_')"/>
            </xsl:attribute>
            <xsl:attribute name="name">
              <xsl:value-of select="translate($shortname, ' ', '_')"/>
            </xsl:attribute>
            <xsl:attribute name="value">
              <xsl:value-of select="@value"/>
            </xsl:attribute>
            <xsl:if test="@value=$answer">
              <xsl:attribute name="checked"/>            
            </xsl:if>
          </input>
          <label class="form-check-label">
            <xsl:attribute name="for">
              <xsl:value-of select="translate($shortname, ' ', '_')"/>
              <xsl:text>-translate($shortname, ' ', '_')</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="title">
              <xsl:value-of select="@optionhover"/>
            </xsl:attribute>
            <xsl:value-of select="@optionshort"/>
          </label>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>
 <xsl:template name="selectcheckbox">
    <xsl:param name="questionid" select="''"/>
    <xsl:param name="shortname" select="''"/>
    <xsl:param name="answer" select="''"/>
    <div class="col col-9">
      <div class="tag-chk-container">
        <xsl:attribute name="data-answer">
          <xsl:value-of select="$answer"/>
        </xsl:attribute>
        <xsl:for-each select="/doc/query[@queryName='options']/row[@questionid=$questionid]">
          <label class="tag-chk-label">
            <xsl:attribute name="title">
              <xsl:value-of select="@optionhover"/>
            </xsl:attribute>
            <input type="checkbox" class="tag-chk" value="{@value}">
              <xsl:attribute name="id">
                <xsl:value-of select="translate($shortname, ' ', '_')"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="translate(@optionshort, ' ', '_')"/>
              </xsl:attribute>
              <xsl:attribute name="name">
                <xsl:value-of select="translate($shortname, ' ', '_')"/>
                <xsl:text>[]</xsl:text>
              </xsl:attribute>
            <xsl:if test="contains($answer, concat(',', @value, ','))">
              <xsl:attribute name="checked"/>
            </xsl:if>
            </input>
            <xsl:value-of select="@optionshort" />
          </label>        
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>
  <xsl:template name="multi-display">
    <xsl:param name="questionid" select="''"/>
    <xsl:param name="shortname" select="''"/>
    <xsl:param name="answer" select="''"/>
    <xsl:param name="answermulti" select="''"/>
      <div class="border border-dark">
          <div class="form-row">
            <div class="col col-auto">
              <label style="margin-left: 10px;">
                <xsl:attribute name="for">
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-source</xsl:text>
                </xsl:attribute>
                Possible:
              </label>
              <select class="form-control" style="height: 120px; width: 250px">
                <xsl:attribute name="id">
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-source</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-source[]</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="multiple"/>
                <xsl:for-each select="/doc/query[@queryName='options']/row[@questionid=$questionid]">
                  <xsl:if test="contains($answermulti, concat(',', @value, ',')) = false">
                    <option value="{@value}">
                      <xsl:attribute name="title">
                        <xsl:value-of select="@optionhover"/>
                      </xsl:attribute>
                      <xsl:value-of select="@optionshort"/>
                    </option>
                  </xsl:if>
                </xsl:for-each>
              </select>
            </div>
            <div class="col col-auto" style="vertical-align: middle;">
              <button class="btn btn-light" type="button" style="margin-bottom: 10px; margin-top: 50px;">
                <xsl:attribute name="name">
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-right</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="onclick">
                  <xsl:text>fadditems(document.getElementById('</xsl:text>
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-source'),document.getElementById('</xsl:text>
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-dest'));</xsl:text>
                </xsl:attribute>
                &#160;&#x21D2;&#160;
              </button>
              <br/>
              <button class="btn btn-light" type="button">
                <xsl:attribute name="name">
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-right</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="onclick">
                  <xsl:text>fdropitems(document.getElementById('</xsl:text>
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-source'),document.getElementById('</xsl:text>
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-dest'));</xsl:text>
                </xsl:attribute>
                &#160;&#x21D0;&#160;
              </button>
            </div>
            <div class="col col-auto">
              <label style="margin-left: 10px;">
                <xsl:attribute name="for">
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-dest</xsl:text>
                </xsl:attribute>
                Selected:
              </label>
              <select class="form-control" style="height: 120px; width: 250px;" data-multidisplay="yes">
                <xsl:attribute name="id">
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>-dest</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="name">
                  <xsl:value-of select="translate($shortname, ' ', '_')"/>
                  <xsl:text>[]</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="multiple"/>
                <xsl:for-each select="/doc/query[@queryName='options']/row[@questionid=$questionid]">
                  <xsl:if test="contains($answermulti, concat(',', @value, ','))">
                    <option value="{@value}">
                      <xsl:attribute name="title">
                        <xsl:value-of select="@optionhover"/>
                      </xsl:attribute>
                      <xsl:value-of select="@optionshort"/>
                    </option>
                  </xsl:if>
                </xsl:for-each>
              </select>
            </div>
          </div>
        </div>
    </xsl:template>
</xsl:stylesheet>