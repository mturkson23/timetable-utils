#!/usr/bin/python

from utils import make_query, execute_query
from xml.etree import ElementTree
from enums import XML_DATA, addparams, get_CTTYPEID
import re


def add_class(node):
    class_id = node.attrib.get('id')
    # instructional offering id
    offeringid = node.attrib.get('offering')
    if offeringid is None:
        offeringid = 'NULL'
    # offering configuration id
    configid = node.attrib.get('config')
    if configid is None:
        configid = 'NULL'
    # scheduling subpart id
    subpartid = node.attrib.get('subpart')
    if subpartid is None:
        subpartid = 'NULL'
    parentid = node.attrib.get('parent')
    if parentid is None:
        parentid = 'NULL'
    # managing department id (this department is used; for room sharing)
    schedulerid = node.attrib.get('scheduler')
    if schedulerid is None:
        schedulerid = 'NULL'
    # controlling department id (this department is only used for
    # departmental balancing constraints)
    departmentid = node.attrib.get('department')
    if departmentid is None:
        departmentid = 'NULL'
    # true for committed classes (committed classes are of different
    # problems (that already have a solution committed), on top of which
    # the current solution is to be built; only committed classes that
    # relate to the current problem (e.g., using the same resource)
    # are included)
    committed = node.attrib.get('committed')
    if committed == 'true':
        committed = '1'
    elif committed == 'false':
        committed = '0'
    elif committed is None:
        committed = 'NULL'

    class_limit = node.attrib.get('classLimit')
    if class_limit is None:
        class_limit = 'NULL'
    min_class_limit = node.attrib.get('minClassLimit')
    if min_class_limit is None:
        min_class_limit = 'NULL'
    max_class_limit = node.attrib.get('maxClassLimit')
    if max_class_limit is None:
        max_class_limit = 'NULL'
    room_to_limit_ratio = node.attrib.get('roomToLimitRatio')
    if room_to_limit_ratio is None:
        # default roomToLimitRatio is 1.0
        room_to_limit_ratio = '1'
    nr_rooms = node.attrib.get('nrRooms')
    if nr_rooms is None:
        nr_rooms = '1'
    dates = node.attrib.get('dates')
    if dates is None:
        dates = 'NULL'
    # prepare class tag SQL add parameters
    xclass = list()
    xclass.append(class_id)
    xclass.append(offeringid)
    xclass.append(configid)
    xclass.append(subpartid)
    xclass.append(parentid)
    xclass.append(schedulerid)
    xclass.append(departmentid)
    xclass.append(committed)
    xclass.append(class_limit)
    xclass.append(min_class_limit)
    xclass.append(max_class_limit)
    xclass.append(room_to_limit_ratio)
    xclass.append(nr_rooms)
    xclass.append('\'' + dates + '\'')

    addparams['tname'] = 'xml_class'
    addparams['xparams'] = xclass
    res = make_query(addparams)
    # call execute to run the prepared query on pg
    class_res = execute_query(res)
    find = re.compile(r"\d+")
    class_id = re.search(find, class_res[0][0]).group(0)
    return class_id


def add_classinstructor(node, class_id):
    for instructor in node.findall('.//instructor'):
        instructor_id = instructor.attrib.get('id')
        solution = instructor.attrib.get('solution')
        if solution == 'true':
            solution = '1'
        elif solution == 'false':
            solution = '0'
        elif solution is None:
            solution = 'NULL'
        # prepare instructor data
        ins = list()
        ins.append(class_id)
        ins.append(instructor_id)
        ins.append(solution)

        addparams['tname'] = 'xml_classinstructor'
        addparams['xparams'] = ins
        ins_query = make_query(addparams)
        # print ins_query
        execute_query(ins_query)


def add_classroom(node, class_id):
    for room in node.findall('.//room'):
        room_id = room.attrib.get('id')
        preference = room.attrib.get('pref')
        solution = room.attrib.get('solution')
        if solution == 'true':
            solution = '1'
        elif solution == 'false':
            solution = '0'
        elif solution is None:
            solution = 'NULL'
        # prepare class//room data
        crm = list()
        crm.append(class_id)
        crm.append(room_id)
        crm.append('\'' + preference + '\'')
        crm.append(solution)

        addparams['tname'] = 'xml_classroom'
        addparams['xparams'] = crm
        ins_query = make_query(addparams)
        # print crm_query
        execute_query(ins_query)


def add_classtime(node, class_id):
    for time in node.findall('.//time'):
        days = time.attrib.get('days')
        start = time.attrib.get('start')
        length = time.attrib.get('length')

        preference = time.attrib.get('pref')
        if preference is None:
            preference = 'NULL'

        solution = time.attrib.get('solution')
        if solution == 'true':
            solution = '1'
        elif solution == 'false':
            solution = '0'
        elif solution is None:
            solution = 'NULL'

        # prepare class//time data
        ctm = list()
        ctm.append(class_id)
        ctm.append('\'' + days + '\'')
        ctm.append(start)
        ctm.append(length)
        ctm.append('\'' + preference + '\'')
        ctm.append(solution)

        addparams['tname'] = 'xml_classtime'
        addparams['xparams'] = ctm
        ctm_query = make_query(addparams)
        # print ctm_query
        execute_query(ctm_query)


def insert_classes():
    with open(XML_DATA, 'rt') as f:
        tree = ElementTree.parse(f)
    for node in tree.findall('.//classes/class'):
        # class attributes
        class_id = add_class(node)

        # class instructor attributes
        add_classinstructor(node, class_id)

        # class room attributes
        add_classroom(node, class_id)

        # class time attributes
        add_classtime(node, class_id)
