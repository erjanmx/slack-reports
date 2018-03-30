library Assortment;

import "dart:html";
import "dart:async";

class Assortment {
  Assortment(Iterable<Element> parents, Iterable<Element> elements) {
    parents.forEach((parent) => addParent(parent));
    elements.forEach((element) => addElement(element));
  }

  Element _parent;
  Element get parent => _parent;

  Element _fromElement;
  Element _dragElement;

  StreamController<Element> _dragEndStreamController = new StreamController<Element>();
  Stream<Element> get onDragEnd => _dragEndStreamController.stream;

  Map<int, List<StreamSubscription>> _subscriptions = {};

  void _addListener(Element el, StreamSubscription sub) {
    if (!_subscriptions.containsKey(el.hashCode)) {
      _subscriptions[el.hashCode] = [sub];
    } else {
      _subscriptions[el.hashCode].add(sub);
    }
  }

  void addParent(Element parent) {

    _addListener(parent, parent.onDragEnter.listen((event) {
      Element ul = (event.currentTarget as Element).children[1];

      if (_dragElement == null || ul.children.length > 0) return;

      ul.append(_dragElement);
    }));

    _addListener(parent, parent.onDragOver.listen((event) {
      event.preventDefault();
    }));

    _addListener(parent, parent.onDrop.listen((event) {
      event.preventDefault();
    }));
  }

  void addElement(Element element) {
    // make element draggable
    element.attributes["draggable"] = "true";

    _addListener(element, element.onDragOver.listen((event) {
      event.preventDefault();
    }));

    _addListener(element, element.onDrop.listen((event) {
      event.preventDefault();
    }));

    _addListener(element, element.onDragStart.listen((event) {
      _dragElement = event.currentTarget;
      event.dataTransfer.effectAllowed = "move";
    }));

    _addListener(element, element.onDragEnter.listen((MouseEvent event) {
      if (_dragElement == null) return;

      Element fromElement = _fromElement;
      Element currentTarget = event.currentTarget;
      _fromElement = event.target;

      if (currentTarget.contains(fromElement)) return;

      Element parent = _dragElement.parent;

      int dragIndex = parent.children.indexOf(_dragElement);
      int preIndex = parent.children.indexOf(event.currentTarget);

      String where = dragIndex < preIndex ? 'afterEnd' : 'beforeBegin';

      currentTarget.insertAdjacentElement(where, _dragElement);
    }));

    _addListener(element, element.onDragEnd.listen((event) {
      _dragEndStreamController.add(_dragElement);
      _dragElement = null;
    }));
  }

  void addElements(Iterable<Element> elements) {
    elements.forEach((element) => addElement(element));
  }
}
