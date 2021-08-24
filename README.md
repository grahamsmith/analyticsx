# Analytics X

![Build](https://github.com/grahamsmith/analyticsx/actions/workflows/main.yaml/badge.svg)

Analytics solution for using multiple vendors.

### The Problem

The User Experience Team / Engineering Manager / Colleague wants to use their favourite flavour of analytics product. The problem is you already have one and you most definitely don't want to write multiple lines of code for each analytics action to cover all the vendors. Analytics is already hard enough at times.

### Analytics X

Analytics X provides 2 simple constructs to allow a simpler setup:

- **Analytics Vendor** - A wrapper around a Analyitcs Vendor (e.g. Firebase, MixPanel etc). Its job is to handle specific Analytic Actions. These are registered during initialisation.
- **Analytics Action** - An object containing all the information required to perform an action. This is passed to all the vendors, which if they can handle the action will process it.

## Getting Started

Installation:

`flutter pub add analyticsx`

Usage:

* Initialise the library with one or more `AnalyticsVendor` objects
* Call `invokeAction` to pass an `AnalyticsAction` to all vendors

```dart
import 'package:analyticsx/actions/track_event.dart';
import 'package:analyticsx/analytics_x.dart';
import 'package:analyticsx/vendors/firebase.dart';
import 'package:flutter/material.dart';

void main() {
  AnalyticsX().init([Firebase()]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AnalyticsX().invokeAction(TrackEvent('test_event', {'test-param': 'yes'}));
    return MaterialApp(
        title: 'Analytics X Example'
    );
  }
}
```

## API

### AnalyticsX

#### init(\[...vendors\])

Before any analytics events can be emitted to vendors, vendors need to be registered with the AnalyticsX static 
library via the `init` function. This in turn will call the `init()` method on the AnalyticsVendor (see below). This 
method can 
be called multiple times to register additional vendors (e.g. where different providers require initialising at 
different points in the application's lifecycle), but are always cumulative. Passing the same vendor multiple times 
will only ever `init()` the vendor once.

#### invokeAction(AnalyticsAction action, \[List\<String\>\] vendorIds)

Passes an analytics event to a vendor. Passes the action to the `handleAction` of each AnalyticsVendor.

Where `vendorIds` is specified, the event is emitted only to those vendors. 

### AnalyticsVendor

An abstraction of the Analytics Vendor's SDK for AnalyticsX. The library comes with Firebase already implemented. An 
additional implementation is shown in the example project.

#### init()

Any initialisation required by the vendor's SDK. Called once only, when this AnalyticsVendor object is passed to the 
AnalyticsX `init` method.

#### handleAction(AnalyticsAction action)

Implementation of how to pass the action (of whatever type) into the Vendor SDK. It is expected for `AnalyticsVendor` 
authors to write this method such that any `AnalyticsAction` can be passed and the method acts on only the actions 
it understands.

Example:
```dart
  void handleAction(AnalyticsAction action) {
    if (action is TrackEvent) {
      analytics.logEvent(name: action.eventName, parameters: action.parameters);
    }

    if (action is SetScreen) {
      analytics.setCurrentScreen(screenName: action.screenName);
    }
  }
```

### AnalyticsAction

A representation of the analytics action (e.g. event, screen, count) required in order for the Vendor to record the 
action taken. This is a plain Dart object containing properties (a PODO?), typically implemented with a constructor 
that takes values for the properties, allowing the implementing application to quickly record an action.

Application example:
```dart
    void doSomething() {
      AnalyticsX().invokeAction(SimpleAnalyticsAction('test_event', {'test-param': 'yes'}));
    }
```

## Contributions

Very welcome :)

### Dev Setup

* Check out code
* `flutter pub get`
* Write code
