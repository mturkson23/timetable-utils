#!/usr/bin/python
from utils import make_query, execute_query
from xml.etree import ElementTree
from enums import XML_DATA, addparams


def add_student(node, studentid):
    std = [studentid]
    addparams['tname'] = 'xml_student'
    addparams['xparams'] = std
    std_query = make_query(addparams)
    execute_query(std_query)


def add_offering(node, studentid):
    for off in node.findall('.//offering'):
        offeringid = off.get('id')
        weight = off.get('weight')
        if weight is None:
            weight = 'NULL'
        offering = [studentid, offeringid, weight]
        addparams['tname'] = 'xml_studentoffering'
        addparams['xparams'] = offering
        off_query = make_query(addparams)
        execute_query(off_query)


def add_studentclass(node, studentid):
    for scl in node.findall('.//class'):
        classid = scl.get('id')
        studentclass = [studentid, classid]
        addparams['tname'] = 'xml_studentclass'
        addparams['xparams'] = studentclass
        scl_query = make_query(addparams)
        execute_query(scl_query)


def add_prohibitedclass(node, studentid):
    for pro in node.findall('.//prohibited-class'):
        classid = pro.get('id')
        prohibitedclass = [studentid, classid]
        addparams['tname'] = 'xml_prohibitedclass'
        addparams['xparams'] = prohibitedclass
        pro_query = make_query(addparams)
        execute_query(pro_query)


def insert_students():
    with open(XML_DATA, 'rt') as f:
        tree = ElementTree.parse(f)
    for node in tree.findall('.//students/student'):
        # student attributes
        studentid = node.attrib.get('id')

        add_student(node, studentid)

        if node.findall('.//offering'):
            add_offering(node, studentid)

        if node.findall('.//class'):
            add_studentclass(node, studentid)

        if node.findall('.//prohibited-class'):
            add_prohibitedclass(node, studentid)
