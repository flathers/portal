/**
 *    '$RCSfile: PostgresAdapter.java,v $'
 *
 *     '$Author: leinfelder $'
 *       '$Date: 2008-03-01 00:31:48 $'
 *   '$Revision: 1.13 $'
 *
 *  For Details: http://kepler.ecoinformatics.org
 *
 * Copyright (c) 2003 The Regents of the University of California.
 * All rights reserved.
 *
 * Permission is hereby granted, without written agreement and without
 * license or royalty fees, to use, copy, modify, and distribute this
 * software and its documentation for any purpose, provided that the
 * above copyright notice and the following two paragraphs appear in
 * all copies of this software.
 *
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY
 * FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
 * ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN
 * IF THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE
 * PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY
 * OF CALIFORNIA HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT,
 * UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
 */
package org.ecoinformatics.datamanager.database;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.ecoinformatics.datamanager.parser.Attribute;
import org.ecoinformatics.datamanager.parser.AttributeList;
import org.ecoinformatics.datamanager.parser.DateTimeDomain;
import org.ecoinformatics.datamanager.parser.Domain;
import org.ecoinformatics.datamanager.parser.EnumeratedDomain;
import org.ecoinformatics.datamanager.parser.NumericDomain;
import org.ecoinformatics.datamanager.parser.TextDomain;

public class PostgresAdapter extends DatabaseAdapter {
  
  /*
   * Class Fields
   */
  public static final String AND    = "AND";
  public static final String BOOLEAN = "Boolean";
  public static final String CREATETABLE = "CREATE TABLE";
  public static final String DATETIME = "Timestamp";
  public static final String DELETE = "DELETE";
  public static final String DOUBLE = "Double";
  public static final String DROPTABLE = "DROP TABLE";
  public static final String FLOAT = "Float";
  public static final String FROM = "FROM";
  
  public static final String INTEGER = "Integer";
  //public static final String IFEXISTS = Config.getValue(IFEXISTSPATH);
  public static final String LIKE = "LIKE";
  public static final String LONG = "Long";
  public static final String QUESTION = "?";
  public static final String QUOTE = "\"";
  //public static final String FIELDSEPATATOR = Config.getValue(FIELDSPEPATH);
  public static final String SELECT = "SELECT";
  
  //public static final String SETTABLE = Config.getValue(SETTABLEPATH);
  //public static final String SOURCE = Config.getValue(SOURCEPATH);
  //public static final String IGNOREFIRST = Config.getValue(IGNOREFIRSTPATH);
  public static final String STRING = "String";
  
  public static final String WHERE = "WHERE";
  
  
  
  /*
   * Instance Fields
   */
  
  
  /*
   * Constructors
   */
  public PostgresAdapter() {
	  super();
	  //override the superclass version
	  this.TO_DATE_FUNCTION = "to_timestamp";
  }
  
  
  /*
   * Class Methods
   */
  
  
  /*
   * Instance Methods
   */

  /**
   * Create a SQL command to generate a table
   * 
   * @param  attributeList   List of attributes that determine the table columns
   * @param  tableName       The table name.
   * @return A string containing the DDL needed to create the table with
   *         its columns
   */
  public String generateDDL(AttributeList attributeList, String tableName)
          throws SQLException {
   String attributeSQL;
   StringBuffer stringBuffer = new StringBuffer();
   //String textFileName   = table.getFileName();
   //int    headLineNumber = table.getNumHeaderLines();
   //String orientation    = table.getOrientation();
   //String delimiter      = table.getDelimiter();
   
   stringBuffer.append(CREATETABLE);
   stringBuffer.append(SPACE);
   stringBuffer.append(tableName);
   stringBuffer.append(LEFTPARENTH);
   attributeSQL = parseAttributeList(attributeList);
   stringBuffer.append(attributeSQL);
   stringBuffer.append(RIGHTPARENTH);
   stringBuffer.append(SEMICOLON);
   String sqlStr = stringBuffer.toString();

   //if (isDebugging) { 
   //  log.debug("The command to create tables is "+sqlStr);
   // }
   return sqlStr;
  }

  
  /**
   * Create a drop table SQL command.
   * 
   * @param tableName  Name of the table to be dropped
   * @return   A SQL string that can be used to drop the table.
   */
  public String generateDropTableSQL(String tableName)
  {
    String sqlString = DROPTABLE + SPACE + tableName + SPACE + SEMICOLON;
    
    return sqlString;
  }
  
  
  /**
   * Gets attribute type for a given attribute. Attribute types include:
   *   "datetime"
   *   "string"
   * or, for numeric attributes, one of the allowed EML NumberType values:
   *   "natural"
   *   "whole"
   *   "integer"
   *   "real"
   * 
   * @param  attribute   The Attribute object whose type is being determined.
   * @return a string value representing the attribute type
   */
  protected String getAttributeType(Attribute attribute) {
    String attributeType = null;
    
    // Check whether attributeType has already been stored for this attribute
    attributeType = attribute.getAttributeType();
    if (attributeType != null) {
      // If the attribute already knows its attributeType, return it now
      return attributeType;
    }
    
    String className = this.getClass().getName();
    attributeType = getAttributeTypeFromStorageType(attribute, className);
    if (attributeType != null) {
      // If the attributeType can be derived from the storageType(s),
      // store it in the attribute object and return it now
      attribute.setAttributeType(attributeType);
      return attributeType;
    }
    
    // Derive the attributeType from the domain type
    attributeType = "string";
    Domain domain = attribute.getDomain();

    if (domain instanceof DateTimeDomain) {
    	attributeType = "datetime";
    }
    else if (domain instanceof EnumeratedDomain
            || domain instanceof TextDomain) {
          attributeType = "string";
        } 
    else if (domain instanceof NumericDomain) {
      NumericDomain numericDomain = (NumericDomain) domain;
      attributeType = numericDomain.getNumberType();
    }

    // Store the attributeType in the attribute so that it doesn't
    // need to be recalculated with every row of data.
    if (attribute != null) {
      attribute.setAttributeType(attributeType);
    }
    
    return attributeType;
  }
		  
	 
  /**
   * Gets the postgresql database type based on a given attribute type.
   * 
   * @param  attributeType   a string indicating the attribute type
   * @return  a string indicating the corresponding data type in Postgres
   */
  protected String mapDataType(String attributeType) {
    String dbDataType;
    Map<String, String> map = new HashMap<String, String>();

    map.put("string", "TEXT");
    map.put("integer", "INTEGER");
    map.put("real", "FLOAT");
    map.put("whole", "INTEGER");
    map.put("natural", "INTEGER");
    map.put("datetime", "TIMESTAMP");

    dbDataType = map.get(attributeType.toLowerCase());

    return dbDataType;
  }

      
  /**
   * Transform ANSI selection sql to a native db sql command.
   * Not yet implemented.
   * 
   * @param ANSISQL   ANSI SQL string.
   * @return          Native Postgres string.
   */
  public String transformSelectionSQL(String ANSISQL) {
    String sqlString = "";

    return sqlString;
  }
	
    
  /**
   * Get the sql command to count how many rows are in a given table.
   * 
   * @param  tableName  the given table name
   * @return the sql string which can count how many rows
   */
  public String getCountingRowNumberSQL(String tableName) {
    String selectString = "SELECT COUNT(*) FROM " + tableName;
    return selectString;
  }
	
}
