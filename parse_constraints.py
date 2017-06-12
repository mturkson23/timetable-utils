#!/usr/bin/python

from utils import make_query, execute_query
from xml.etree import ElementTree
from enums import XML_DATA, addparams, get_CTTYPEID
import re


def add_constraintclass(node, conid):
    for ccl in node.findall('.//class'):
        classid = ccl.get('id')
        params = [conid, classid]
        addparams['tname'] = 'constraintclass'
        addparams['xparams'] = params
        ccl_query = make_query(addparams)
        execute_query(ccl_query)


def add_parentclass(node, conid):
    for pcl in node.findall('.//parentClass'):
        pclassid = pcl.get('id')
        params = [conid, pclassid]
        addparams['tname'] = 'constraintparentclass'
        addparams['xparams'] = params
        pcl_query = make_query(addparams)
        execute_query(pcl_query)


def add_constraint(node, params):
    addparams['tname'] = 'xml_groupconstraint'
    addparams['xparams'] = params
    con_query = make_query(addparams)
    # print con_query
    con_res = execute_query(con_query)
    find = re.compile(r"\d+")
    gc_id = re.search(find, con_res[0][0]).group(0)
    return gc_id


def insert_groupconstraints():
    with open(XML_DATA, 'rt') as f:
        tree = ElementTree.parse(f)
    for node in tree.findall('.//groupConstraints/constraint'):
        conid = node.attrib.get('id')
        contype = node.attrib.get('type')
        conpref = node.attrib.get('pref')
        if conpref is None:
            conpref = 'NULL'
        courselimit = node.attrib.get('courseLimit')
        if courselimit is None:
            courselimit = 'NULL'
        delta = node.attrib.get('delta')
        if delta is None:
            delta = 'NULL'

        # add constraint
        gc_id = add_constraint(node, [
                        conid,
                        get_CTTYPEID(contype),
                        '\'' + conpref + '\'',
                        courselimit,
                        delta])

        if node.findall('.//class'):
            add_constraintclass(node, gc_id)

        if node.findall('.//parentClass'):
            add_parentclass(node, gc_id)
