var pas = {};

var rtl = {

  version: 10501,

  quiet: false,
  debug_load_units: false,
  debug_rtti: false,

  debug: function(){
    if (rtl.quiet || !console || !console.log) return;
    console.log(arguments);
  },

  error: function(s){
    rtl.debug('Error: ',s);
    throw s;
  },

  warn: function(s){
    rtl.debug('Warn: ',s);
  },

  checkVersion: function(v){
    if (rtl.version != v) throw "expected rtl version "+v+", but found "+rtl.version;
  },

  hiInt: Math.pow(2,53),

  hasString: function(s){
    return rtl.isString(s) && (s.length>0);
  },

  isArray: function(a) {
    return Array.isArray(a);
  },

  isFunction: function(f){
    return typeof(f)==="function";
  },

  isModule: function(m){
    return rtl.isObject(m) && rtl.hasString(m.$name) && (pas[m.$name]===m);
  },

  isImplementation: function(m){
    return rtl.isObject(m) && rtl.isModule(m.$module) && (m.$module.$impl===m);
  },

  isNumber: function(n){
    return typeof(n)==="number";
  },

  isObject: function(o){
    var s=typeof(o);
    return (typeof(o)==="object") && (o!=null);
  },

  isString: function(s){
    return typeof(s)==="string";
  },

  getNumber: function(n){
    return typeof(n)==="number"?n:NaN;
  },

  getChar: function(c){
    return ((typeof(c)==="string") && (c.length===1)) ? c : "";
  },

  getObject: function(o){
    return ((typeof(o)==="object") || (typeof(o)==='function')) ? o : null;
  },

  isTRecord: function(type){
    return (rtl.isObject(type) && type.hasOwnProperty('$new') && (typeof(type.$new)==='function'));
  },

  isPasClass: function(type){
    return (rtl.isObject(type) && type.hasOwnProperty('$classname') && rtl.isObject(type.$module));
  },

  isPasClassInstance: function(type){
    return (rtl.isObject(type) && rtl.isPasClass(type.$class));
  },

  hexStr: function(n,digits){
    return ("000000000000000"+n.toString(16).toUpperCase()).slice(-digits);
  },

  m_loading: 0,
  m_loading_intf: 1,
  m_intf_loaded: 2,
  m_loading_impl: 3, // loading all used unit
  m_initializing: 4, // running initialization
  m_initialized: 5,

  module: function(module_name, intfuseslist, intfcode, impluseslist, implcode){
    if (rtl.debug_load_units) rtl.debug('rtl.module name="'+module_name+'" intfuses='+intfuseslist+' impluses='+impluseslist+' hasimplcode='+rtl.isFunction(implcode));
    if (!rtl.hasString(module_name)) rtl.error('invalid module name "'+module_name+'"');
    if (!rtl.isArray(intfuseslist)) rtl.error('invalid interface useslist of "'+module_name+'"');
    if (!rtl.isFunction(intfcode)) rtl.error('invalid interface code of "'+module_name+'"');
    if (!(impluseslist==undefined) && !rtl.isArray(impluseslist)) rtl.error('invalid implementation useslist of "'+module_name+'"');
    if (!(implcode==undefined) && !rtl.isFunction(implcode)) rtl.error('invalid implementation code of "'+module_name+'"');

    if (pas[module_name])
      rtl.error('module "'+module_name+'" is already registered');

    var module = pas[module_name] = {
      $name: module_name,
      $intfuseslist: intfuseslist,
      $impluseslist: impluseslist,
      $state: rtl.m_loading,
      $intfcode: intfcode,
      $implcode: implcode,
      $impl: null,
      $rtti: Object.create(rtl.tSectionRTTI)
    };
    module.$rtti.$module = module;
    if (implcode) module.$impl = {
      $module: module,
      $rtti: module.$rtti
    };
  },

  exitcode: 0,

  run: function(module_name){
  
    function doRun(){
      if (!rtl.hasString(module_name)) module_name='program';
      if (rtl.debug_load_units) rtl.debug('rtl.run module="'+module_name+'"');
      rtl.initRTTI();
      var module = pas[module_name];
      if (!module) rtl.error('rtl.run module "'+module_name+'" missing');
      rtl.loadintf(module);
      rtl.loadimpl(module);
      if (module_name=='program'){
        if (rtl.debug_load_units) rtl.debug('running $main');
        var r = pas.program.$main();
        if (rtl.isNumber(r)) rtl.exitcode = r;
      }
    }
    
    if (rtl.showUncaughtExceptions) {
      try{
        doRun();
      } catch(re) {
        var errMsg = rtl.hasString(re.$classname) ? re.$classname : '';
	    errMsg +=  ((errMsg) ? ': ' : '') + (re.hasOwnProperty('fMessage') ? re.fMessage : re);
        alert('Uncaught Exception : '+errMsg);
        rtl.exitCode = 216;
      }
    } else {
      doRun();
    }
    return rtl.exitcode;
  },

  loadintf: function(module){
    if (module.$state>rtl.m_loading_intf) return; // already finished
    if (rtl.debug_load_units) rtl.debug('loadintf: "'+module.$name+'"');
    if (module.$state===rtl.m_loading_intf)
      rtl.error('unit cycle detected "'+module.$name+'"');
    module.$state=rtl.m_loading_intf;
    // load interfaces of interface useslist
    rtl.loaduseslist(module,module.$intfuseslist,rtl.loadintf);
    // run interface
    if (rtl.debug_load_units) rtl.debug('loadintf: run intf of "'+module.$name+'"');
    module.$intfcode(module.$intfuseslist);
    // success
    module.$state=rtl.m_intf_loaded;
    // Note: units only used in implementations are not yet loaded (not even their interfaces)
  },

  loaduseslist: function(module,useslist,f){
    if (useslist==undefined) return;
    for (var i in useslist){
      var unitname=useslist[i];
      if (rtl.debug_load_units) rtl.debug('loaduseslist of "'+module.$name+'" uses="'+unitname+'"');
      if (pas[unitname]==undefined)
        rtl.error('module "'+module.$name+'" misses "'+unitname+'"');
      f(pas[unitname]);
    }
  },

  loadimpl: function(module){
    if (module.$state>=rtl.m_loading_impl) return; // already processing
    if (module.$state<rtl.m_intf_loaded) rtl.error('loadimpl: interface not loaded of "'+module.$name+'"');
    if (rtl.debug_load_units) rtl.debug('loadimpl: load uses of "'+module.$name+'"');
    module.$state=rtl.m_loading_impl;
    // load interfaces of implementation useslist
    rtl.loaduseslist(module,module.$impluseslist,rtl.loadintf);
    // load implementation of interfaces useslist
    rtl.loaduseslist(module,module.$intfuseslist,rtl.loadimpl);
    // load implementation of implementation useslist
    rtl.loaduseslist(module,module.$impluseslist,rtl.loadimpl);
    // Note: At this point all interfaces used by this unit are loaded. If
    //   there are implementation uses cycles some used units might not yet be
    //   initialized. This is by design.
    // run implementation
    if (rtl.debug_load_units) rtl.debug('loadimpl: run impl of "'+module.$name+'"');
    if (rtl.isFunction(module.$implcode)) module.$implcode(module.$impluseslist);
    // run initialization
    if (rtl.debug_load_units) rtl.debug('loadimpl: run init of "'+module.$name+'"');
    module.$state=rtl.m_initializing;
    if (rtl.isFunction(module.$init)) module.$init();
    // unit initialized
    module.$state=rtl.m_initialized;
  },

  createCallback: function(scope, fn){
    var cb;
    if (typeof(fn)==='string'){
      cb = function(){
        return scope[fn].apply(scope,arguments);
      };
    } else {
      cb = function(){
        return fn.apply(scope,arguments);
      };
    };
    cb.scope = scope;
    cb.fn = fn;
    return cb;
  },

  cloneCallback: function(cb){
    return rtl.createCallback(cb.scope,cb.fn);
  },

  eqCallback: function(a,b){
    // can be a function or a function wrapper
    if (a==b){
      return true;
    } else {
      return (a!=null) && (b!=null) && (a.fn) && (a.scope===b.scope) && (a.fn==b.fn);
    }
  },

  initStruct: function(c,parent,name){
    if ((parent.$module) && (parent.$module.$impl===parent)) parent=parent.$module;
    c.$parent = parent;
    if (rtl.isModule(parent)){
      c.$module = parent;
      c.$name = name;
    } else {
      c.$module = parent.$module;
      c.$name = parent.$name+'.'+name;
    };
    return parent;
  },

  initClass: function(c,parent,name,initfn){
    parent[name] = c;
    c.$class = c; // Note: o.$class === Object.getPrototypeOf(o)
    c.$classname = name;
    parent = rtl.initStruct(c,parent,name);
    c.$fullname = parent.$name+'.'+name;
    // rtti
    if (rtl.debug_rtti) rtl.debug('initClass '+c.$fullname);
    var t = c.$module.$rtti.$Class(c.$name,{ "class": c });
    c.$rtti = t;
    if (rtl.isObject(c.$ancestor)) t.ancestor = c.$ancestor.$rtti;
    if (!t.ancestor) t.ancestor = null;
    // init members
    initfn.call(c);
  },

  createClass: function(parent,name,ancestor,initfn){
    // create a normal class,
    // ancestor must be null or a normal class,
    // the root ancestor can be an external class
    var c = null;
    if (ancestor != null){
      c = Object.create(ancestor);
      c.$ancestor = ancestor;
      // Note:
      // if root is an "object" then c.$ancestor === Object.getPrototypeOf(c)
      // if root is a "function" then c.$ancestor === c.__proto__, Object.getPrototypeOf(c) returns the root
    } else {
      c = {};
      c.$create = function(fn,args){
        if (args == undefined) args = [];
        var o = Object.create(this);
        o.$init();
        try{
          if (typeof(fn)==="string"){
            o[fn].apply(o,args);
          } else {
            fn.apply(o,args);
          };
          o.AfterConstruction();
        } catch($e){
          // do not call BeforeDestruction
          if (o.Destroy) o.Destroy();
          o.$final();
          throw $e;
        }
        return o;
      };
      c.$destroy = function(fnname){
        this.BeforeDestruction();
        if (this[fnname]) this[fnname]();
        this.$final();
      };
    };
    rtl.initClass(c,parent,name,initfn);
  },

  createClassExt: function(parent,name,ancestor,newinstancefnname,initfn){
    // Create a class using an external ancestor.
    // If newinstancefnname is given, use that function to create the new object.
    // If exist call BeforeDestruction and AfterConstruction.
    var c = Object.create(ancestor);
    c.$create = function(fn,args){
      if (args == undefined) args = [];
      var o = null;
      if (newinstancefnname.length>0){
        o = this[newinstancefnname](fn,args);
      } else {
        o = Object.create(this);
      }
      if (o.$init) o.$init();
      try{
        if (typeof(fn)==="string"){
          o[fn].apply(o,args);
        } else {
          fn.apply(o,args);
        };
        if (o.AfterConstruction) o.AfterConstruction();
      } catch($e){
        // do not call BeforeDestruction
        if (o.Destroy) o.Destroy();
        if (o.$final) this.$final();
        throw $e;
      }
      return o;
    };
    c.$destroy = function(fnname){
      if (this.BeforeDestruction) this.BeforeDestruction();
      if (this[fnname]) this[fnname]();
      if (this.$final) this.$final();
    };
    rtl.initClass(c,parent,name,initfn);
  },

  createHelper: function(parent,name,ancestor,initfn){
    // create a helper,
    // ancestor must be null or a helper,
    var c = null;
    if (ancestor != null){
      c = Object.create(ancestor);
      c.$ancestor = ancestor;
      // c.$ancestor === Object.getPrototypeOf(c)
    } else {
      c = {};
    };
    parent[name] = c;
    c.$class = c; // Note: o.$class === Object.getPrototypeOf(o)
    c.$classname = name;
    parent = rtl.initStruct(c,parent,name);
    c.$fullname = parent.$name+'.'+name;
    // rtti
    var t = c.$module.$rtti.$Helper(c.$name,{ "helper": c });
    c.$rtti = t;
    if (rtl.isObject(ancestor)) t.ancestor = ancestor.$rtti;
    if (!t.ancestor) t.ancestor = null;
    // init members
    initfn.call(c);
  },

  tObjectDestroy: "Destroy",

  free: function(obj,name){
    if (obj[name]==null) return null;
    obj[name].$destroy(rtl.tObjectDestroy);
    obj[name]=null;
  },

  freeLoc: function(obj){
    if (obj==null) return null;
    obj.$destroy(rtl.tObjectDestroy);
    return null;
  },

  recNewT: function(parent,name,initfn,full){
    // create new record type
    var t = {};
    if (parent) parent[name] = t;
    function hide(prop){
      Object.defineProperty(t,prop,{enumerable:false});
    }
    if (full){
      rtl.initStruct(t,parent,name);
      t.$record = t;
      hide('$record');
      hide('$name');
      hide('$parent');
      hide('$module');
    }
    initfn.call(t);
    if (!t.$new){
      t.$new = function(){ return Object.create(this); };
    }
    t.$clone = function(r){ return this.$new().$assign(r); };
    hide('$new');
    hide('$clone');
    hide('$eq');
    hide('$assign');
    return t;
  },

  is: function(instance,type){
    return type.isPrototypeOf(instance) || (instance===type);
  },

  isExt: function(instance,type,mode){
    // mode===1 means instance must be a Pascal class instance
    // mode===2 means instance must be a Pascal class
    // Notes:
    // isPrototypeOf and instanceof return false on equal
    // isPrototypeOf does not work for Date.isPrototypeOf(new Date())
    //   so if isPrototypeOf is false test with instanceof
    // instanceof needs a function on right side
    if (instance == null) return false; // Note: ==null checks for undefined too
    if ((typeof(type) !== 'object') && (typeof(type) !== 'function')) return false;
    if (instance === type){
      if (mode===1) return false;
      if (mode===2) return rtl.isPasClass(instance);
      return true;
    }
    if (type.isPrototypeOf && type.isPrototypeOf(instance)){
      if (mode===1) return rtl.isPasClassInstance(instance);
      if (mode===2) return rtl.isPasClass(instance);
      return true;
    }
    if ((typeof type == 'function') && (instance instanceof type)) return true;
    return false;
  },

  Exception: null,
  EInvalidCast: null,
  EAbstractError: null,
  ERangeError: null,
  EIntOverflow: null,
  EPropWriteOnly: null,

  raiseE: function(typename){
    var t = rtl[typename];
    if (t==null){
      var mod = pas.SysUtils;
      if (!mod) mod = pas.sysutils;
      if (mod){
        t = mod[typename];
        if (!t) t = mod[typename.toLowerCase()];
        if (!t) t = mod['Exception'];
        if (!t) t = mod['exception'];
      }
    }
    if (t){
      if (t.Create){
        throw t.$create("Create");
      } else if (t.create){
        throw t.$create("create");
      }
    }
    if (typename === "EInvalidCast") throw "invalid type cast";
    if (typename === "EAbstractError") throw "Abstract method called";
    if (typename === "ERangeError") throw "range error";
    throw typename;
  },

  as: function(instance,type){
    if((instance === null) || rtl.is(instance,type)) return instance;
    rtl.raiseE("EInvalidCast");
  },

  asExt: function(instance,type,mode){
    if((instance === null) || rtl.isExt(instance,type,mode)) return instance;
    rtl.raiseE("EInvalidCast");
  },

  createInterface: function(module, name, guid, fnnames, ancestor, initfn){
    //console.log('createInterface name="'+name+'" guid="'+guid+'" names='+fnnames);
    var i = ancestor?Object.create(ancestor):{};
    module[name] = i;
    i.$module = module;
    i.$name = name;
    i.$fullname = module.$name+'.'+name;
    i.$guid = guid;
    i.$guidr = null;
    i.$names = fnnames?fnnames:[];
    if (rtl.isFunction(initfn)){
      // rtti
      if (rtl.debug_rtti) rtl.debug('createInterface '+i.$fullname);
      var t = i.$module.$rtti.$Interface(name,{ "interface": i, module: module });
      i.$rtti = t;
      if (ancestor) t.ancestor = ancestor.$rtti;
      if (!t.ancestor) t.ancestor = null;
      initfn.call(i);
    }
    return i;
  },

  strToGUIDR: function(s,g){
    var p = 0;
    function n(l){
      var h = s.substr(p,l);
      p+=l;
      return parseInt(h,16);
    }
    p+=1; // skip {
    g.D1 = n(8);
    p+=1; // skip -
    g.D2 = n(4);
    p+=1; // skip -
    g.D3 = n(4);
    p+=1; // skip -
    if (!g.D4) g.D4=[];
    g.D4[0] = n(2);
    g.D4[1] = n(2);
    p+=1; // skip -
    for(var i=2; i<8; i++) g.D4[i] = n(2);
    return g;
  },

  guidrToStr: function(g){
    if (g.$intf) return g.$intf.$guid;
    var h = rtl.hexStr;
    var s='{'+h(g.D1,8)+'-'+h(g.D2,4)+'-'+h(g.D3,4)+'-'+h(g.D4[0],2)+h(g.D4[1],2)+'-';
    for (var i=2; i<8; i++) s+=h(g.D4[i],2);
    s+='}';
    return s;
  },

  createTGUID: function(guid){
    var TGuid = (pas.System)?pas.System.TGuid:pas.system.tguid;
    var g = rtl.strToGUIDR(guid,TGuid.$new());
    return g;
  },

  getIntfGUIDR: function(intfTypeOrVar){
    if (!intfTypeOrVar) return null;
    if (!intfTypeOrVar.$guidr){
      var g = rtl.createTGUID(intfTypeOrVar.$guid);
      if (!intfTypeOrVar.hasOwnProperty('$guid')) intfTypeOrVar = Object.getPrototypeOf(intfTypeOrVar);
      g.$intf = intfTypeOrVar;
      intfTypeOrVar.$guidr = g;
    }
    return intfTypeOrVar.$guidr;
  },

  addIntf: function (aclass, intf, map){
    function jmp(fn){
      if (typeof(fn)==="function"){
        return function(){ return fn.apply(this.$o,arguments); };
      } else {
        return function(){ rtl.raiseE('EAbstractError'); };
      }
    }
    if(!map) map = {};
    var t = intf;
    var item = Object.create(t);
    if (!aclass.hasOwnProperty('$intfmaps')) aclass.$intfmaps = {};
    aclass.$intfmaps[intf.$guid] = item;
    do{
      var names = t.$names;
      if (!names) break;
      for (var i=0; i<names.length; i++){
        var intfname = names[i];
        var fnname = map[intfname];
        if (!fnname) fnname = intfname;
        //console.log('addIntf: intftype='+t.$name+' index='+i+' intfname="'+intfname+'" fnname="'+fnname+'" old='+typeof(item[intfname]));
        item[intfname] = jmp(aclass[fnname]);
      }
      t = Object.getPrototypeOf(t);
    }while(t!=null);
  },

  getIntfG: function (obj, guid, query){
    if (!obj) return null;
    //console.log('getIntfG: obj='+obj.$classname+' guid='+guid+' query='+query);
    // search
    var maps = obj.$intfmaps;
    if (!maps) return null;
    var item = maps[guid];
    if (!item) return null;
    // check delegation
    //console.log('getIntfG: obj='+obj.$classname+' guid='+guid+' query='+query+' item='+typeof(item));
    if (typeof item === 'function') return item.call(obj); // delegate. Note: COM contains _AddRef
    // check cache
    var intf = null;
    if (obj.$interfaces){
      intf = obj.$interfaces[guid];
      //console.log('getIntfG: obj='+obj.$classname+' guid='+guid+' cache='+typeof(intf));
    }
    if (!intf){ // intf can be undefined!
      intf = Object.create(item);
      intf.$o = obj;
      if (!obj.$interfaces) obj.$interfaces = {};
      obj.$interfaces[guid] = intf;
    }
    if (typeof(query)==='object'){
      // called by queryIntfT
      var o = null;
      if (intf.QueryInterface(rtl.getIntfGUIDR(query),
          {get:function(){ return o; }, set:function(v){ o=v; }}) === 0){
        return o;
      } else {
        return null;
      }
    } else if(query===2){
      // called by TObject.GetInterfaceByStr
      if (intf.$kind === 'com') intf._AddRef();
    }
    return intf;
  },

  getIntfT: function(obj,intftype){
    return rtl.getIntfG(obj,intftype.$guid);
  },

  queryIntfT: function(obj,intftype){
    return rtl.getIntfG(obj,intftype.$guid,intftype);
  },

  queryIntfIsT: function(obj,intftype){
    var i = rtl.queryIntfG(obj,intftype.$guid);
    if (!i) return false;
    if (i.$kind === 'com') i._Release();
    return true;
  },

  asIntfT: function (obj,intftype){
    var i = rtl.getIntfG(obj,intftype.$guid);
    if (i!==null) return i;
    rtl.raiseEInvalidCast();
  },

  intfIsClass: function(intf,classtype){
    return (intf!=null) && (rtl.is(intf.$o,classtype));
  },

  intfAsClass: function(intf,classtype){
    if (intf==null) return null;
    return rtl.as(intf.$o,classtype);
  },

  intfToClass: function(intf,classtype){
    if ((intf!==null) && rtl.is(intf.$o,classtype)) return intf.$o;
    return null;
  },

  // interface reference counting
  intfRefs: { // base object for temporary interface variables
    ref: function(id,intf){
      // called for temporary interface references needing delayed release
      var old = this[id];
      //console.log('rtl.intfRefs.ref: id='+id+' old="'+(old?old.$name:'null')+'" intf="'+(intf?intf.$name:'null')+' $o='+(intf?intf.$o:'null'));
      if (old){
        // called again, e.g. in a loop
        delete this[id];
        old._Release(); // may fail
      }
      this[id]=intf;
      return intf;
    },
    free: function(){
      //console.log('rtl.intfRefs.free...');
      for (var id in this){
        if (this.hasOwnProperty(id)){
          //console.log('rtl.intfRefs.free: id='+id+' '+this[id].$name+' $o='+this[id].$o.$classname);
          this[id]._Release();
        }
      }
    }
  },

  createIntfRefs: function(){
    //console.log('rtl.createIntfRefs');
    return Object.create(rtl.intfRefs);
  },

  setIntfP: function(path,name,value,skipAddRef){
    var old = path[name];
    //console.log('rtl.setIntfP path='+path+' name='+name+' old="'+(old?old.$name:'null')+'" value="'+(value?value.$name:'null')+'"');
    if (old === value) return;
    if (old !== null){
      path[name]=null;
      old._Release();
    }
    if (value !== null){
      if (!skipAddRef) value._AddRef();
      path[name]=value;
    }
  },

  setIntfL: function(old,value,skipAddRef){
    //console.log('rtl.setIntfL old="'+(old?old.$name:'null')+'" value="'+(value?value.$name:'null')+'"');
    if (old !== value){
      if (value!==null){
        if (!skipAddRef) value._AddRef();
      }
      if (old!==null){
        old._Release();  // Release after AddRef, to avoid double Release if Release creates an exception
      }
    } else if (skipAddRef){
      if (old!==null){
        old._Release();  // value has an AddRef
      }
    }
    return value;
  },

  _AddRef: function(intf){
    //if (intf) console.log('rtl._AddRef intf="'+(intf?intf.$name:'null')+'"');
    if (intf) intf._AddRef();
    return intf;
  },

  _Release: function(intf){
    //if (intf) console.log('rtl._Release intf="'+(intf?intf.$name:'null')+'"');
    if (intf) intf._Release();
    return intf;
  },

  checkMethodCall: function(obj,type){
    if (rtl.isObject(obj) && rtl.is(obj,type)) return;
    rtl.raiseE("EInvalidCast");
  },

  oc: function(i){
    // overflow check integer
    if ((Math.floor(i)===i) && (i>=-0x1fffffffffffff) && (i<=0x1fffffffffffff)) return i;
    rtl.raiseE('EIntOverflow');
  },

  rc: function(i,minval,maxval){
    // range check integer
    if ((Math.floor(i)===i) && (i>=minval) && (i<=maxval)) return i;
    rtl.raiseE('ERangeError');
  },

  rcc: function(c,minval,maxval){
    // range check char
    if ((typeof(c)==='string') && (c.length===1)){
      var i = c.charCodeAt(0);
      if ((i>=minval) && (i<=maxval)) return c;
    }
    rtl.raiseE('ERangeError');
  },

  rcSetCharAt: function(s,index,c){
    // range check setCharAt
    if ((typeof(s)!=='string') || (index<0) || (index>=s.length)) rtl.raiseE('ERangeError');
    return rtl.setCharAt(s,index,c);
  },

  rcCharAt: function(s,index){
    // range check charAt
    if ((typeof(s)!=='string') || (index<0) || (index>=s.length)) rtl.raiseE('ERangeError');
    return s.charAt(index);
  },

  rcArrR: function(arr,index){
    // range check read array
    if (Array.isArray(arr) && (typeof(index)==='number') && (index>=0) && (index<arr.length)){
      if (arguments.length>2){
        // arr,index1,index2,...
        arr=arr[index];
        for (var i=2; i<arguments.length; i++) arr=rtl.rcArrR(arr,arguments[i]);
        return arr;
      }
      return arr[index];
    }
    rtl.raiseE('ERangeError');
  },

  rcArrW: function(arr,index,value){
    // range check write array
    // arr,index1,index2,...,value
    for (var i=3; i<arguments.length; i++){
      arr=rtl.rcArrR(arr,index);
      index=arguments[i-1];
      value=arguments[i];
    }
    if (Array.isArray(arr) && (typeof(index)==='number') && (index>=0) && (index<arr.length)){
      return arr[index]=value;
    }
    rtl.raiseE('ERangeError');
  },

  length: function(arr){
    return (arr == null) ? 0 : arr.length;
  },

  arraySetLength: function(arr,defaultvalue,newlength){
    // multi dim: (arr,defaultvalue,dim1,dim2,...)
    if (arr == null) arr = [];
    var p = arguments;
    function setLength(a,argNo){
      var oldlen = a.length;
      var newlen = p[argNo];
      if (oldlen!==newlength){
        a.length = newlength;
        if (argNo === p.length-1){
          if (rtl.isArray(defaultvalue)){
            for (var i=oldlen; i<newlen; i++) a[i]=[]; // nested array
          } else if (rtl.isObject(defaultvalue)) {
            if (rtl.isTRecord(defaultvalue)){
              for (var i=oldlen; i<newlen; i++) a[i]=defaultvalue.$new(); // e.g. record
            } else {
              for (var i=oldlen; i<newlen; i++) a[i]={}; // e.g. set
            }
          } else {
            for (var i=oldlen; i<newlen; i++) a[i]=defaultvalue;
          }
        } else {
          for (var i=oldlen; i<newlen; i++) a[i]=[]; // nested array
        }
      }
      if (argNo < p.length-1){
        // multi argNo
        for (var i=0; i<newlen; i++) a[i]=setLength(a[i],argNo+1);
      }
      return a;
    }
    return setLength(arr,2);
  },

  arrayEq: function(a,b){
    if (a===null) return b===null;
    if (b===null) return false;
    if (a.length!==b.length) return false;
    for (var i=0; i<a.length; i++) if (a[i]!==b[i]) return false;
    return true;
  },

  arrayClone: function(type,src,srcpos,endpos,dst,dstpos){
    // type: 0 for references, "refset" for calling refSet(), a function for new type()
    // src must not be null
    // This function does not range check.
    if(type === 'refSet') {
      for (; srcpos<endpos; srcpos++) dst[dstpos++] = rtl.refSet(src[srcpos]); // ref set
    } else if (rtl.isTRecord(type)){
      for (; srcpos<endpos; srcpos++) dst[dstpos++] = type.$clone(src[srcpos]); // clone record
    }  else {
      for (; srcpos<endpos; srcpos++) dst[dstpos++] = src[srcpos]; // reference
    };
  },

  arrayConcat: function(type){
    // type: see rtl.arrayClone
    var a = [];
    var l = 0;
    for (var i=1; i<arguments.length; i++){
      var src = arguments[i];
      if (src !== null) l+=src.length;
    };
    a.length = l;
    l=0;
    for (var i=1; i<arguments.length; i++){
      var src = arguments[i];
      if (src === null) continue;
      rtl.arrayClone(type,src,0,src.length,a,l);
      l+=src.length;
    };
    return a;
  },

  arrayConcatN: function(){
    var a = null;
    for (var i=1; i<arguments.length; i++){
      var src = arguments[i];
      if (src === null) continue;
      if (a===null){
        a=src; // Note: concat(a) does not clone
      } else {
        a=a.concat(src);
      }
    };
    return a;
  },

  arrayCopy: function(type, srcarray, index, count){
    // type: see rtl.arrayClone
    // if count is missing, use srcarray.length
    if (srcarray === null) return [];
    if (index < 0) index = 0;
    if (count === undefined) count=srcarray.length;
    var end = index+count;
    if (end>srcarray.length) end = srcarray.length;
    if (index>=end) return [];
    if (type===0){
      return srcarray.slice(index,end);
    } else {
      var a = [];
      a.length = end-index;
      rtl.arrayClone(type,srcarray,index,end,a,0);
      return a;
    }
  },

  setCharAt: function(s,index,c){
    return s.substr(0,index)+c+s.substr(index+1);
  },

  getResStr: function(mod,name){
    var rs = mod.$resourcestrings[name];
    return rs.current?rs.current:rs.org;
  },

  createSet: function(){
    var s = {};
    for (var i=0; i<arguments.length; i++){
      if (arguments[i]!=null){
        s[arguments[i]]=true;
      } else {
        var first=arguments[i+=1];
        var last=arguments[i+=1];
        for(var j=first; j<=last; j++) s[j]=true;
      }
    }
    return s;
  },

  cloneSet: function(s){
    var r = {};
    for (var key in s) r[key]=true;
    return r;
  },

  refSet: function(s){
    Object.defineProperty(s, '$shared', {
      enumerable: false,
      configurable: true,
      writable: true,
      value: true
    });
    return s;
  },

  includeSet: function(s,enumvalue){
    if (s.$shared) s = rtl.cloneSet(s);
    s[enumvalue] = true;
    return s;
  },

  excludeSet: function(s,enumvalue){
    if (s.$shared) s = rtl.cloneSet(s);
    delete s[enumvalue];
    return s;
  },

  diffSet: function(s,t){
    var r = {};
    for (var key in s) if (!t[key]) r[key]=true;
    return r;
  },

  unionSet: function(s,t){
    var r = {};
    for (var key in s) r[key]=true;
    for (var key in t) r[key]=true;
    return r;
  },

  intersectSet: function(s,t){
    var r = {};
    for (var key in s) if (t[key]) r[key]=true;
    return r;
  },

  symDiffSet: function(s,t){
    var r = {};
    for (var key in s) if (!t[key]) r[key]=true;
    for (var key in t) if (!s[key]) r[key]=true;
    return r;
  },

  eqSet: function(s,t){
    for (var key in s) if (!t[key]) return false;
    for (var key in t) if (!s[key]) return false;
    return true;
  },

  neSet: function(s,t){
    return !rtl.eqSet(s,t);
  },

  leSet: function(s,t){
    for (var key in s) if (!t[key]) return false;
    return true;
  },

  geSet: function(s,t){
    for (var key in t) if (!s[key]) return false;
    return true;
  },

  strSetLength: function(s,newlen){
    var oldlen = s.length;
    if (oldlen > newlen){
      return s.substring(0,newlen);
    } else if (s.repeat){
      // Note: repeat needs ECMAScript6!
      return s+' '.repeat(newlen-oldlen);
    } else {
       while (oldlen<newlen){
         s+=' ';
         oldlen++;
       };
       return s;
    }
  },

  spaceLeft: function(s,width){
    var l=s.length;
    if (l>=width) return s;
    if (s.repeat){
      // Note: repeat needs ECMAScript6!
      return ' '.repeat(width-l) + s;
    } else {
      while (l<width){
        s=' '+s;
        l++;
      };
    };
  },

  floatToStr: function(d,w,p){
    // input 1-3 arguments: double, width, precision
    if (arguments.length>2){
      return rtl.spaceLeft(d.toFixed(p),w);
    } else {
	  // exponent width
	  var pad = "";
	  var ad = Math.abs(d);
	  if (ad<1.0e+10) {
		pad='00';
	  } else if (ad<1.0e+100) {
		pad='0';
      }  	
	  if (arguments.length<2) {
	    w=9;		
      } else if (w<9) {
		w=9;
      }		  
      var p = w-8;
      var s=(d>0 ? " " : "" ) + d.toExponential(p);
      s=s.replace(/e(.)/,'E$1'+pad);
      return rtl.spaceLeft(s,w);
    }
  },

  valEnum: function(s, enumType, setCodeFn){
    s = s.toLowerCase();
    for (var key in enumType){
      if((typeof(key)==='string') && (key.toLowerCase()===s)){
        setCodeFn(0);
        return enumType[key];
      }
    }
    setCodeFn(1);
    return 0;
  },

  and: function(a,b){
    var hi = 0x80000000;
    var low = 0x7fffffff;
    var h = (a / hi) & (b / hi);
    var l = (a & low) & (b & low);
    return h*hi + l;
  },

  or: function(a,b){
    var hi = 0x80000000;
    var low = 0x7fffffff;
    var h = (a / hi) | (b / hi);
    var l = (a & low) | (b & low);
    return h*hi + l;
  },

  xor: function(a,b){
    var hi = 0x80000000;
    var low = 0x7fffffff;
    var h = (a / hi) ^ (b / hi);
    var l = (a & low) ^ (b & low);
    return h*hi + l;
  },

  shr: function(a,b){
    if (a<0) a += rtl.hiInt;
    if (a<0x80000000) return a >> b;
    if (b<=0) return a;
    if (b>54) return 0;
    return Math.floor(a / Math.pow(2,b));
  },

  shl: function(a,b){
    if (a<0) a += rtl.hiInt;
    if (b<=0) return a;
    if (b>54) return 0;
    var r = a * Math.pow(2,b);
    if (r <= rtl.hiInt) return r;
    return r % rtl.hiInt;
  },

  initRTTI: function(){
    if (rtl.debug_rtti) rtl.debug('initRTTI');

    // base types
    rtl.tTypeInfo = { name: "tTypeInfo" };
    function newBaseTI(name,kind,ancestor){
      if (!ancestor) ancestor = rtl.tTypeInfo;
      if (rtl.debug_rtti) rtl.debug('initRTTI.newBaseTI "'+name+'" '+kind+' ("'+ancestor.name+'")');
      var t = Object.create(ancestor);
      t.name = name;
      t.kind = kind;
      rtl[name] = t;
      return t;
    };
    function newBaseInt(name,minvalue,maxvalue,ordtype){
      var t = newBaseTI(name,1 /* tkInteger */,rtl.tTypeInfoInteger);
      t.minvalue = minvalue;
      t.maxvalue = maxvalue;
      t.ordtype = ordtype;
      return t;
    };
    newBaseTI("tTypeInfoInteger",1 /* tkInteger */);
    newBaseInt("shortint",-0x80,0x7f,0);
    newBaseInt("byte",0,0xff,1);
    newBaseInt("smallint",-0x8000,0x7fff,2);
    newBaseInt("word",0,0xffff,3);
    newBaseInt("longint",-0x80000000,0x7fffffff,4);
    newBaseInt("longword",0,0xffffffff,5);
    newBaseInt("nativeint",-0x10000000000000,0xfffffffffffff,6);
    newBaseInt("nativeuint",0,0xfffffffffffff,7);
    newBaseTI("char",2 /* tkChar */);
    newBaseTI("string",3 /* tkString */);
    newBaseTI("tTypeInfoEnum",4 /* tkEnumeration */,rtl.tTypeInfoInteger);
    newBaseTI("tTypeInfoSet",5 /* tkSet */);
    newBaseTI("double",6 /* tkDouble */);
    newBaseTI("boolean",7 /* tkBool */);
    newBaseTI("tTypeInfoProcVar",8 /* tkProcVar */);
    newBaseTI("tTypeInfoMethodVar",9 /* tkMethod */,rtl.tTypeInfoProcVar);
    newBaseTI("tTypeInfoArray",10 /* tkArray */);
    newBaseTI("tTypeInfoDynArray",11 /* tkDynArray */);
    newBaseTI("tTypeInfoPointer",15 /* tkPointer */);
    var t = newBaseTI("pointer",15 /* tkPointer */,rtl.tTypeInfoPointer);
    t.reftype = null;
    newBaseTI("jsvalue",16 /* tkJSValue */);
    newBaseTI("tTypeInfoRefToProcVar",17 /* tkRefToProcVar */,rtl.tTypeInfoProcVar);

    // member kinds
    rtl.tTypeMember = {};
    function newMember(name,kind){
      var m = Object.create(rtl.tTypeMember);
      m.name = name;
      m.kind = kind;
      rtl[name] = m;
    };
    newMember("tTypeMemberField",1); // tmkField
    newMember("tTypeMemberMethod",2); // tmkMethod
    newMember("tTypeMemberProperty",3); // tmkProperty

    // base object for storing members: a simple object
    rtl.tTypeMembers = {};

    // tTypeInfoStruct - base object for tTypeInfoClass, tTypeInfoRecord, tTypeInfoInterface
    var tis = newBaseTI("tTypeInfoStruct",0);
    tis.$addMember = function(name,ancestor,options){
      if (rtl.debug_rtti){
        if (!rtl.hasString(name) || (name.charAt()==='$')) throw 'invalid member "'+name+'", this="'+this.name+'"';
        if (!rtl.is(ancestor,rtl.tTypeMember)) throw 'invalid ancestor "'+ancestor+':'+ancestor.name+'", "'+this.name+'.'+name+'"';
        if ((options!=undefined) && (typeof(options)!='object')) throw 'invalid options "'+options+'", "'+this.name+'.'+name+'"';
      };
      var t = Object.create(ancestor);
      t.name = name;
      this.members[name] = t;
      this.names.push(name);
      if (rtl.isObject(options)){
        for (var key in options) if (options.hasOwnProperty(key)) t[key] = options[key];
      };
      return t;
    };
    tis.addField = function(name,type,options){
      var t = this.$addMember(name,rtl.tTypeMemberField,options);
      if (rtl.debug_rtti){
        if (!rtl.is(type,rtl.tTypeInfo)) throw 'invalid type "'+type+'", "'+this.name+'.'+name+'"';
      };
      t.typeinfo = type;
      this.fields.push(name);
      return t;
    };
    tis.addFields = function(){
      var i=0;
      while(i<arguments.length){
        var name = arguments[i++];
        var type = arguments[i++];
        if ((i<arguments.length) && (typeof(arguments[i])==='object')){
          this.addField(name,type,arguments[i++]);
        } else {
          this.addField(name,type);
        };
      };
    };
    tis.addMethod = function(name,methodkind,params,result,options){
      var t = this.$addMember(name,rtl.tTypeMemberMethod,options);
      t.methodkind = methodkind;
      t.procsig = rtl.newTIProcSig(params);
      t.procsig.resulttype = result?result:null;
      this.methods.push(name);
      return t;
    };
    tis.addProperty = function(name,flags,result,getter,setter,options){
      var t = this.$addMember(name,rtl.tTypeMemberProperty,options);
      t.flags = flags;
      t.typeinfo = result;
      t.getter = getter;
      t.setter = setter;
      // Note: in options: params, stored, defaultvalue
      if (rtl.isArray(t.params)) t.params = rtl.newTIParams(t.params);
      this.properties.push(name);
      if (!rtl.isString(t.stored)) t.stored = "";
      return t;
    };
    tis.getField = function(index){
      return this.members[this.fields[index]];
    };
    tis.getMethod = function(index){
      return this.members[this.methods[index]];
    };
    tis.getProperty = function(index){
      return this.members[this.properties[index]];
    };

    newBaseTI("tTypeInfoRecord",12 /* tkRecord */,rtl.tTypeInfoStruct);
    newBaseTI("tTypeInfoClass",13 /* tkClass */,rtl.tTypeInfoStruct);
    newBaseTI("tTypeInfoClassRef",14 /* tkClassRef */);
    newBaseTI("tTypeInfoInterface",18 /* tkInterface */,rtl.tTypeInfoStruct);
    newBaseTI("tTypeInfoHelper",19 /* tkHelper */,rtl.tTypeInfoStruct);
  },

  tSectionRTTI: {
    $module: null,
    $inherited: function(name,ancestor,o){
      if (rtl.debug_rtti){
        rtl.debug('tSectionRTTI.newTI "'+(this.$module?this.$module.$name:"(no module)")
          +'"."'+name+'" ('+ancestor.name+') '+(o?'init':'forward'));
      };
      var t = this[name];
      if (t){
        if (!t.$forward) throw 'duplicate type "'+name+'"';
        if (!ancestor.isPrototypeOf(t)) throw 'typeinfo ancestor mismatch "'+name+'" ancestor="'+ancestor.name+'" t.name="'+t.name+'"';
      } else {
        t = Object.create(ancestor);
        t.name = name;
        t.$module = this.$module;
        this[name] = t;
      }
      if (o){
        delete t.$forward;
        for (var key in o) if (o.hasOwnProperty(key)) t[key]=o[key];
      } else {
        t.$forward = true;
      }
      return t;
    },
    $Scope: function(name,ancestor,o){
      var t=this.$inherited(name,ancestor,o);
      t.members = {};
      t.names = [];
      t.fields = [];
      t.methods = [];
      t.properties = [];
      return t;
    },
    $TI: function(name,kind,o){ var t=this.$inherited(name,rtl.tTypeInfo,o); t.kind = kind; return t; },
    $Int: function(name,o){ return this.$inherited(name,rtl.tTypeInfoInteger,o); },
    $Enum: function(name,o){ return this.$inherited(name,rtl.tTypeInfoEnum,o); },
    $Set: function(name,o){ return this.$inherited(name,rtl.tTypeInfoSet,o); },
    $StaticArray: function(name,o){ return this.$inherited(name,rtl.tTypeInfoArray,o); },
    $DynArray: function(name,o){ return this.$inherited(name,rtl.tTypeInfoDynArray,o); },
    $ProcVar: function(name,o){ return this.$inherited(name,rtl.tTypeInfoProcVar,o); },
    $RefToProcVar: function(name,o){ return this.$inherited(name,rtl.tTypeInfoRefToProcVar,o); },
    $MethodVar: function(name,o){ return this.$inherited(name,rtl.tTypeInfoMethodVar,o); },
    $Record: function(name,o){ return this.$Scope(name,rtl.tTypeInfoRecord,o); },
    $Class: function(name,o){ return this.$Scope(name,rtl.tTypeInfoClass,o); },
    $ClassRef: function(name,o){ return this.$inherited(name,rtl.tTypeInfoClassRef,o); },
    $Pointer: function(name,o){ return this.$inherited(name,rtl.tTypeInfoPointer,o); },
    $Interface: function(name,o){ return this.$Scope(name,rtl.tTypeInfoInterface,o); },
    $Helper: function(name,o){ return this.$Scope(name,rtl.tTypeInfoHelper,o); }
  },

  newTIParam: function(param){
    // param is an array, 0=name, 1=type, 2=optional flags
    var t = {
      name: param[0],
      typeinfo: param[1],
      flags: (rtl.isNumber(param[2]) ? param[2] : 0)
    };
    return t;
  },

  newTIParams: function(list){
    // list: optional array of [paramname,typeinfo,optional flags]
    var params = [];
    if (rtl.isArray(list)){
      for (var i=0; i<list.length; i++) params.push(rtl.newTIParam(list[i]));
    };
    return params;
  },

  newTIProcSig: function(params,result,flags){
    var s = {
      params: rtl.newTIParams(params),
      resulttype: result,
      flags: flags
    };
    return s;
  }
}
rtl.module("System",[],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TObject",null,function () {
    this.$init = function () {
    };
    this.$final = function () {
    };
    this.AfterConstruction = function () {
    };
    this.BeforeDestruction = function () {
    };
  });
  this.Random = function (Range) {
    return Math.floor(Math.random()*Range);
  };
  this.Copy = function (S, Index, Size) {
    if (Index<1) Index = 1;
    return (Size>0) ? S.substring(Index-1,Index+Size-1) : "";
  };
  this.Copy$1 = function (S, Index) {
    if (Index<1) Index = 1;
    return S.substr(Index-1);
  };
  this.Delete = function (S, Index, Size) {
    var h = "";
    if ((Index < 1) || (Index > S.get().length) || (Size <= 0)) return;
    h = S.get();
    S.set($mod.Copy(h,1,Index - 1) + $mod.Copy$1(h,Index + Size));
  };
  $mod.$init = function () {
    rtl.exitcode = 0;
  };
});
rtl.module("JS",["System"],function () {
  "use strict";
  var $mod = this;
});
rtl.module("SysUtils",["System","JS"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  this.TStringReplaceFlag = {"0": "rfReplaceAll", rfReplaceAll: 0, "1": "rfIgnoreCase", rfIgnoreCase: 1};
  this.StringReplace = function (aOriginal, aSearch, aReplace, Flags) {
    var Result = "";
    var REFlags = "";
    var REString = "";
    REFlags = "";
    if (0 in Flags) REFlags = "g";
    if (1 in Flags) REFlags = REFlags + "i";
    REString = aSearch.replace(new RegExp($impl.RESpecials,"g"),"\\$1");
    Result = aOriginal.replace(new RegExp(REString,REFlags),aReplace);
    return Result;
  };
  this.IntToStr = function (Value) {
    var Result = "";
    Result = "" + Value;
    return Result;
  };
  this.TryStrToInt = function (S, res) {
    var Result = false;
    var NI = 0;
    Result = $mod.TryStrToInt$1(S,{get: function () {
        return NI;
      }, set: function (v) {
        NI = v;
      }});
    if (Result) res.set(NI);
    return Result;
  };
  this.TryStrToInt$1 = function (S, res) {
    var Result = false;
    var Radix = 10;
    var N = "";
    var J = undefined;
    N = S;
    var $tmp1 = pas.System.Copy(N,1,1);
    if ($tmp1 === "$") {
      Radix = 16}
     else if ($tmp1 === "&") {
      Radix = 8}
     else if ($tmp1 === "%") Radix = 2;
    if (Radix !== 10) pas.System.Delete({get: function () {
        return N;
      }, set: function (v) {
        N = v;
      }},1,1);
    J = parseInt(N,Radix);
    Result = !isNaN(J);
    if (Result) res.set(Math.floor(J));
    return Result;
  };
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.RESpecials = "([\\+\\[\\]\\(\\)\\\\\\.\\*])";
});
rtl.module("Classes",["System","SysUtils"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $mod.$init = function () {
    $impl.ClassList = Object.create(null);
  };
},["JS"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.ClassList = null;
});
rtl.module("Web",["System","JS"],function () {
  "use strict";
  var $mod = this;
});
rtl.module("unt_GrueStewBase",["System","Classes","SysUtils"],function () {
  "use strict";
  var $mod = this;
  this.TDir = {"0": "drNorth", drNorth: 0, "1": "drEast", drEast: 1, "2": "drSouth", drSouth: 2, "3": "drWest", drWest: 3};
  this.TMoveResult = {"0": "mvOK", mvOK: 0, "1": "mvWall", mvWall: 1, "2": "mvExit", mvExit: 2, "3": "mvExitwMonst", mvExitwMonst: 3, "4": "mvMonster", mvMonster: 4, "5": "mvPit", mvPit: 5, "6": "mvBat", mvBat: 6, "7": "mvEarthquake", mvEarthquake: 7};
  this.TShootResult = {"0": "shHit", shHit: 0, "1": "shWall", shWall: 1, "2": "shMiss", shMiss: 2, "3": "shMiss2", shMiss2: 3, "4": "shMiss3", shMiss3: 4, "5": "shEarthquake", shEarthquake: 5};
  this.TSens = {"0": "snExit", snExit: 0, "1": "snSnMonster", snSnMonster: 1, "2": "snBat", snBat: 2, "3": "snPit", snPit: 3};
  this.LineEnding = "\r\n";
  this.rsRaumTxt01 = "Sie sind in einem kleinen Raum mit überall verstreut liegenden Felsen und " + "Gesteinstrümmern.";
  this.rsRaumTxt02 = "Sie müssen tief gebückt weitergehen. Riesige Stalagtiten hängen von der Decke " + "und nehmen Ihnen die Sicht";
  this.RaumTxt = [$mod.rsRaumTxt01,$mod.rsRaumTxt02,"Der Gang ist sehr schmal und niedrig, Sie müssen sich durchzwängen","Der Höhlenboden wird immer steiler und rutschiger. - Vorsicht !","Sie befinden sich in einem riesigen Saal, in der Mitte können Sie einen hohen " + "Felsen erkennen","Sie durchqueren eine enge Passage zwischen zwei Räumen, Geröll rieselt von " + "der Decke","Die Decke senkt sich immer tiefer, schnell Sie müssen darunter durchkriechen","Ein sehr gefährlicher Aufenthalt, die Höhle wurde vom letzten Erdbeben " + "betroffen und ist teilweise eingestürzt.","Sie befinden sich in einem Mittelgroßen Raum - angefüllt mit einem fahlen " + "Nebel. Achtung! Der Nebel ist gefährlich - er droht Ihnen den Atem zu nehmen.","Ihr Licht ist erloschen, Sie können sich nur noch tastend vorwärtsbewegen","Sie befinden sich in einem gewundenen Stollen, der Boden ist schlüpfrig " + "und von breiten Rissen durchzogen","Sie sind in einem steill abfallenden Durchgang.","Der Durchgang wird enger","Sie sind in einem runden Saal mit mehreren Ausgängen.","Sie erreichen einen wassergefüllten Graben und müssen Schwimmen.","Ein kleines Loch über Ihnen lässt einen fahlen Lichtschein durch... aber " + "es ist viel zu klein.","Jemand hat eine angezündete Laterne in einer Nische zurückgelassen - " + "Ihr Weg wird hell erleuchtet.","Ein Rinnsal sickert aus einer Ritze in der Wand.","Ein winziger Durchbruch erregt Ihre Aufmerksamkeit; Er ist für sie zu schmal.","Der Hunger nagt an ihren Eingeweiden, deshalb sind Sie total erschöpft " + "und fallen beim Wassertrinken in den unterirdischen Fluß " + $mod.LineEnding + "Sie werden davongerissen und an einer gänzlich unbekannten " + "Gegend auf den Felsen geschleudert."];
  this.RaumTxt2 = ["##","[]","  ","kR","VV","nG","rB","Sa","eP","sD","mR","NN","Dk","gS","aD","eD","rS","wG","fL","aL","RW","wD","uF"];
  this.SensTxt = ["Der Ausgang ist ganz nahe ...","Sie riechen das Ungeheuer !!!","Schlürf...Schlürf...Schlürf...","Sie spüren einen Luftzug !!!"];
  this.ITryMove = ["Nach Norden also ...","Es geht also nach Osten ...","Sie versuchen es nach Süden ...","Let's go West ..."];
  this.IShoot = ["Sie zielen nach Norden und der Pfeil schiesst los ...","Sie zielen Richtung Osten und der Pfeil geht ab ...","Der Pfeil schießt Richtung Süden  ...","Er nam den Bogen, den besten, und schoß den Pfeil nach Westen ..."];
  this.CDirDesc = ["drNorth","drEast","drSouth","drWest"];
  this.CDirShortDesc = ["N","O","S","W"];
  $mod.$resourcestrings = {Anleitung: {org: "In diesem Spiel sind sie ein tapferer und sehr #hunriger Jäger#. Deshalb beschließen Sie sich einen ungeheuren #Eintopf# zu kochen. Wie jedemann weiß ist jedoch ein #Ungeheuer# die Grundlage dieses Gerichts.\r\nAuf der Suche nach der Hauptzutat des Eintopfs dringen sie in ein #düsteres Labyrinth# vor.\r\nWenn Sie ein Ungeheuer erlegen ist Ihnen ein ausreichender #Eintopf# sicher (und sie haben das Spiel gewonnen).\r\nEinmal im Irrgarten, können Sie entweder weiter vordringen oder einen Pfeil in eine benachberte Höhle abschießen - in der Hoffnung, das Ungeheuer zu Treffen.\r\nIch werde Sie deshalb fragen was Sie tun wollen.\r\nMögliche Anworten sind die 4 Richtungen in Groß- oder Kleinbuchstaben.\r\nGroßbuchstaben zum Marschieren, Kleinbuchstaben zum schießen, wenn Sie das Ungeheuer treffen sollten, teile ich Ihnen das mit. Sie müssen es zum Ausgang schleppen.\r\nAber... Es gibt auch noch andere Dinge im Höhlenlabyrinth. Riesige Fledermäuse ergreifen Sie, und werfen Sie irgendwo ab. \r\nEs gibt alles verschlingende Abgründe, die Sie nie wieder freigeben!\r\nUnd natürlich das Ungeheuer selbst. Diese angriffslustige Bestie wird Sie auffressen, bevor sie sich zur Flucht wenden können.\r\nErdbeben werfen alles durcheinander, Verschütten Ausgänge usw."}, EQuake: {org: "Erdbe.b..e...n >>>"}, CantMoveThere: {org: "Sie versuche es, aber da geht es nicht weiter ..."}, BatCatchYou: {org: "Die Fledermäuße greifen an!!!\r\nSie werden hochgehoben !!!\r\n...Wo sind sie gelandet ???"}, CHeader: {org: "\r\n        *** Grue Stew ***\r\n"}, CMap: {org: "Karte:"}, CPressAnyKey: {org: "Drücken Sie eine beliebige Taste ..."}, CAnweisung: {org: "Drücken Sie <n>,<o>,<s>,<w> zum schießen in die Richtung\r\n        <N>,<O>,<S>,<W> zum bewegen in die Richtung\r\n        <?> für Hilfe und  <Q> zum Beenden"}, HitMonster: {org: "... und erlegt das Monster. Herzlichen Glückwunsch! Jetzt nur noch schnell zum Ausgang"}, HitWall: {org: "... und trifft die Wand"}, NoHit1: {org: "... und trifft ins leere"}, NoHit2: {org: "... und trifft nichts"}, NoHit3: {org: "... und trifft daneben"}, ReachedExit: {org: "Toll, der Ausgang ist erreicht, leider haben Sie kein Monster erlegt, so müssen sie weiter hungern ... "}, ReachedExitwM: {org: "Hurra, der Ausgang ist erreicht! Mit dem Monster können sie sich jetzt einen köstlichen Eintopf kochen  ... "}, CaughtBYMonster: {org: "Das Monster hat sie erwischt. Jetzt ist's aus ... "}, FellIntoPit: {org: "AAAAhhh ..  hh . hh ..h ..... \r\nSie fallen, und fallen ..."}};
});
rtl.module("cls_GrueStewEng",["System","Classes","SysUtils","unt_GrueStewBase"],function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  rtl.recNewT($mod,"TRoom",function () {
    this.ID = 0;
    this.Desc = "";
    this.Reachable = 0;
    this.MappedR = false;
    this.$new = function () {
      var r = Object.create(this);
      r.MappedT = rtl.arraySetLength(null,false,4);
      r.Transition = rtl.arraySetLength(null,0,4);
      return r;
    };
    this.$eq = function (b) {
      return (this.ID === b.ID) && (this.Desc === b.Desc) && (this.Reachable === b.Reachable) && (this.MappedR === b.MappedR) && rtl.arrayEq(this.MappedT,b.MappedT) && rtl.arrayEq(this.Transition,b.Transition);
    };
    this.$assign = function (s) {
      this.ID = s.ID;
      this.Desc = s.Desc;
      this.Reachable = s.Reachable;
      this.MappedR = s.MappedR;
      this.MappedT = s.MappedT.slice(0);
      this.Transition = s.Transition.slice(0);
      return this;
    };
  });
  rtl.createClass($mod,"TGrueStewEng",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.FRooms = [];
      this.FStep = 0;
      this.FPlayerRoom = 0;
      this.FExitRoom = 0;
      this.FGrueRoom = 0;
      this.FGameEnded = false;
      this.FGrueKilled = false;
      this.FLastMRes = 0;
      this.FBatRoom1 = 0;
      this.FBatRoom2 = 0;
      this.FPitRoom1 = 0;
      this.FPitRoom2 = 0;
    };
    this.$final = function () {
      this.FRooms = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.GetSensSet = function () {
      var Result = {};
      var dir = 0;
      Result = {};
      for (dir = 0; dir <= 3; dir++) if (this.FRooms[this.FPlayerRoom].Transition[dir] !== 0) {
        if (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FGrueRoom) Result = rtl.unionSet(Result,rtl.createSet(1));
        if (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FExitRoom) Result = rtl.unionSet(Result,rtl.createSet(0));
        if (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FPitRoom1) Result = rtl.unionSet(Result,rtl.createSet(3));
        if (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FPitRoom2) Result = rtl.unionSet(Result,rtl.createSet(3));
        if (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FBatRoom1) Result = rtl.unionSet(Result,rtl.createSet(2));
        if (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FBatRoom2) Result = rtl.unionSet(Result,rtl.createSet(2));
      };
      return Result;
    };
    this.DoEarthQuake = function () {
      this.SetObstacle();
    };
    this.SetTransition = function (i, dir, Force) {
      var Result = false;
      var Dest = 0;
      var rDir = 0;
      var flag = false;
      while (((pas.System.Random(3) + 1) !== 2) && (this.FRooms[i].Transition[dir] === 0)) {
        Dest = $impl.MyRandom(20,i);
        if ((Force > 0) && (this.FRooms[i].Reachable === 0) && (this.FRooms[Dest].Reachable === 0)) continue;
        if ((Force > 1) && ((this.FRooms[i].Reachable === 0) === (this.FRooms[Dest].Reachable === 0))) continue;
        flag = false;
        for (rDir = 0; rDir <= 3; rDir++) if (this.FRooms[Dest].Transition[rDir] === i) {
          flag = true;
          break;
        };
        rDir = (dir + 2) % (pas.unt_GrueStewBase.TDir.drWest + 1);
        if (!flag && (this.FRooms[Dest].Transition[rDir] === 0)) {
          this.FRooms[i].Transition[dir] = Dest;
          this.FRooms[Dest].Transition[rDir] = i;
          if ((this.FRooms[i].Reachable !== 0) && (this.FRooms[Dest].Reachable === 0)) {
            this.FRooms[Dest].Reachable = this.FRooms[i].Reachable + 1;
            for (rDir = 0; rDir <= 3; rDir++) if ((this.FRooms[Dest].Transition[rDir] !== 0) && (this.FRooms[this.FRooms[Dest].Transition[rDir]].Reachable === 0)) this.FRooms[this.FRooms[Dest].Transition[rDir]].Reachable = this.FRooms[i].Reachable + 2;
          } else if ((this.FRooms[i].Reachable === 0) && (this.FRooms[Dest].Reachable !== 0)) {
            this.FRooms[i].Reachable = this.FRooms[Dest].Reachable + 1;
            for (rDir = 0; rDir <= 3; rDir++) if ((this.FRooms[i].Transition[rDir] !== 0) && (this.FRooms[this.FRooms[i].Transition[rDir]].Reachable === 0)) this.FRooms[this.FRooms[i].Transition[rDir]].Reachable = this.FRooms[Dest].Reachable + 2;
          };
        };
      };
      Result = this.FRooms[i].Transition[dir] !== 0;
      if (Result && (this.FRooms[i].Reachable === 0)) if (this.FRooms[this.FRooms[i].Transition[dir]].Reachable !== 0) this.FRooms[i].Reachable = this.FRooms[this.FRooms[i].Transition[dir]].Reachable + 1;
      return Result;
    };
    this.GetRoomDesc = function () {
      var Result = "";
      var asens = 0;
      Result = this.FRooms[this.FPlayerRoom].Desc;
      for (var $l1 in this.GetSensSet()) {
        asens = +$l1;
        Result = Result + pas.unt_GrueStewBase.LineEnding + pas.unt_GrueStewBase.SensTxt[asens];
      };
      return Result;
    };
    this.GetMap = function (dir) {
      var Result = 0;
      if (!this.FRooms[this.FPlayerRoom].MappedT[dir]) {
        Result = 0}
       else if (this.FRooms[this.FPlayerRoom].Transition[dir] === 0) {
        Result = -2}
       else if (!this.FRooms[this.FRooms[this.FPlayerRoom].Transition[dir]].MappedR) {
        Result = -1}
       else Result = this.FRooms[this.FPlayerRoom].Transition[dir];
      return Result;
    };
    this.InitLaby = function () {
      var flag = false;
      var success = false;
      var dir = 0;
      var i = 0;
      var TrC = 0;
      var bailout = 0;
      this.FGrueKilled = false;
      this.FGameEnded = false;
      this.FStep = 0;
      this.FRooms = rtl.arraySetLength(this.FRooms,$mod.TRoom,20 + 1);
      success = false;
      while (!success) {
        bailout = 0;
        for (i = 1; i <= 20; i++) {
          this.FRooms[i].MappedR = false;
          this.FRooms[i].Reachable = 0;
          this.FRooms[i].ID = i;
          for (dir = 0; dir <= 3; dir++) {
            this.FRooms[i].Transition[dir] = 0;
            this.FRooms[i].MappedT[dir] = false;
          };
          this.FRooms[i].Desc = pas.unt_GrueStewBase.RaumTxt[i - 1];
        };
        this.FRooms[1].Reachable = 1;
        for (i = 1; i <= 20; i++) {
          flag = false;
          TrC = 0;
          while (!flag && (TrC < 4) && (bailout < 5000)) {
            TrC = 0;
            bailout += 1;
            for (dir = 0; dir <= 3; dir++) if (this.SetTransition(i,dir,Math.floor(i / 7))) {
              flag = true;
              TrC += 1;
            };
            if (i > 7) flag = flag && (this.FRooms[i].Reachable !== 0);
          };
        };
        for (i = 1; i <= 7; i++) while ((this.FRooms[i].Reachable === 0) && (bailout < 5000)) {
          bailout += 1;
          for (dir = 0; dir <= 3; dir++) this.SetTransition(i,dir,1);
        };
        success = bailout < 500;
      };
    };
    this.SetObstacle = function () {
      if (this.FGrueKilled) {
        this.FGrueRoom = -1}
       else this.FGrueRoom = $impl.MyRandom(20,this.FPlayerRoom);
      this.FExitRoom = pas.System.Random(20) + 1;
      this.FBatRoom1 = $impl.MyRandom(20,this.FPlayerRoom);
      this.FBatRoom2 = $impl.MyRandom(20,this.FPlayerRoom);
      this.FPitRoom1 = $impl.MyRandom(20,this.FPlayerRoom);
      this.FPitRoom2 = $impl.MyRandom(20,this.FPlayerRoom);
    };
    this.InitPlayer = function () {
      this.FPlayerRoom = pas.System.Random(20) + 1;
      this.FRooms[this.FPlayerRoom].MappedR = true;
    };
    this.Create$1 = function () {
      this.FGameEnded = true;
      return this;
    };
    this.GetDescription = function () {
      var Result = "";
      Result = rtl.getResStr(pas.unt_GrueStewBase,"Anleitung");
      return Result;
    };
    this.NewGame = function () {
      this.InitLaby();
      this.InitPlayer();
      this.SetObstacle();
    };
    this.Move = function (dir) {
      var Result = 0;
      if (this.FGameEnded) return this.FLastMRes;
      this.FStep += 1;
      if (pas.System.Random(15) === 4) {
        this.DoEarthQuake();
        return 7;
      };
      if (this.FRooms[this.FPlayerRoom].Transition[dir] === 0) {
        this.FRooms[this.FPlayerRoom].MappedT[dir] = true;
        return 1;
      };
      if (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FExitRoom) {
        this.FGameEnded = true;
        if (this.FGrueKilled) {
          this.FLastMRes = 3}
         else this.FLastMRes = 2;
        return this.FLastMRes;
      };
      if (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FGrueRoom) {
        this.FGameEnded = true;
        this.FLastMRes = 4;
        return 4;
      };
      if ((this.FRooms[this.FPlayerRoom].Transition[dir] === this.FPitRoom1) || (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FPitRoom2)) {
        this.FGameEnded = true;
        this.FLastMRes = 5;
        return 5;
      };
      if ((this.FRooms[this.FPlayerRoom].Transition[dir] === this.FBatRoom1) || (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FBatRoom2)) {
        this.FRooms[this.FPlayerRoom].MappedT[dir] = true;
        this.FPlayerRoom = pas.System.Random(20) + 1;
        this.FRooms[this.FPlayerRoom].MappedR = true;
        return 6;
      };
      this.FRooms[this.FPlayerRoom].MappedT[dir] = true;
      this.FPlayerRoom = this.FRooms[this.FPlayerRoom].Transition[dir];
      this.FRooms[this.FPlayerRoom].MappedT[(dir + 2) % (pas.unt_GrueStewBase.TDir.drWest + 1)] = true;
      this.FRooms[this.FPlayerRoom].MappedR = true;
      this.FLastMRes = 0;
      Result = 0;
      return Result;
    };
    this.Shoot = function (dir) {
      var Result = 0;
      if (this.FGameEnded) return 2;
      this.FStep += 1;
      if (pas.System.Random(15) === 4) {
        this.DoEarthQuake();
        return 5;
      };
      this.FRooms[this.FPlayerRoom].MappedT[dir] = true;
      if (this.FRooms[this.FPlayerRoom].Transition[dir] === 0) return 1;
      if (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FGrueRoom) {
        this.FGrueKilled = true;
        this.FGrueRoom = -1;
        return 0;
      };
      if ((this.FRooms[this.FPlayerRoom].Transition[dir] === this.FPitRoom1) || (this.FRooms[this.FPlayerRoom].Transition[dir] === this.FPitRoom2)) return 3;
      Result = 2;
      return Result;
    };
  });
},null,function () {
  "use strict";
  var $mod = this;
  var $impl = $mod.$impl;
  $impl.MyRandom = function (max, gap) {
    var Result = 0;
    Result = pas.System.Random(max - 1) + 1;
    if (Result >= gap) Result += 1;
    return Result;
  };
});
rtl.module("Frw_GrueStewMain",["System","JS","Classes","SysUtils","Web","cls_GrueStewEng","unt_GrueStewBase"],function () {
  "use strict";
  var $mod = this;
  rtl.createClass($mod,"TFrwGrueStew",pas.System.TObject,function () {
    this.$init = function () {
      pas.System.TObject.$init.call(this);
      this.pnlMain = null;
      this.pnlInput = null;
      this.pnlStatus = null;
      this.edtTextOut = null;
      this.btnNewGame = null;
      this.lblActRoom = null;
      this.fGrueStew = null;
      this.FMapLbl = rtl.arraySetLength(null,null,4);
      this.FMovBtn = rtl.arraySetLength(null,null,4);
      this.FShtBtn = rtl.arraySetLength(null,null,4);
    };
    this.$final = function () {
      this.pnlMain = undefined;
      this.pnlInput = undefined;
      this.pnlStatus = undefined;
      this.edtTextOut = undefined;
      this.btnNewGame = undefined;
      this.lblActRoom = undefined;
      this.fGrueStew = undefined;
      this.FMapLbl = undefined;
      this.FMovBtn = undefined;
      this.FShtBtn = undefined;
      pas.System.TObject.$final.call(this);
    };
    this.Create$1 = function () {
      var $Self = this;
      function CreateMemoEdit(aName) {
        var Result = null;
        Result = document.createElement("textarea");
        Result.name = aName;
        Result.setAttribute("id","memo " + aName);
        Result.setAttribute("rows","25");
        Result.setAttribute("cols","80");
        return Result;
      };
      function CreateSmallButton(aName, aCaption) {
        var Result = null;
        Result = document.createElement("input");
        Result.setAttribute("id",aName);
        Result.setAttribute("type","submit");
        Result.setAttribute("value",aCaption);
        Result.name = aName;
        Result.setAttribute("style","width: 40px; height: 40px;");
        Result.setAttribute("class","btn btn-default");
        return Result;
      };
      function CreateNButton(aName, aCaption) {
        var Result = null;
        Result = document.createElement("input");
        Result.setAttribute("id",aName);
        Result.setAttribute("type","submit");
        Result.setAttribute("value",aCaption);
        Result.name = aName;
        Result.setAttribute("style","width: 160px;");
        Result.setAttribute("class","btn btn-default");
        return Result;
      };
      function CreateLabel(aName, aCaption) {
        var Result = null;
        Result = document.createTextNode(aCaption);
        return Result;
      };
      var ltable = null;
      var ltableRow = null;
      var ltableCell = null;
      var dir = 0;
      $Self.fGrueStew = pas.cls_GrueStewEng.TGrueStewEng.$create("Create$1");
      $Self.pnlMain = document.createElement("div");
      $Self.pnlMain.setAttribute("class","panel panel-default");
      $Self.pnlInput = document.createElement("div");
      $Self.pnlInput.setAttribute("class","panel-body");
      $Self.pnlInput.setAttribute("align","center");
      $Self.pnlStatus = document.createElement("div");
      $Self.pnlStatus.setAttribute("class","panel-body");
      $Self.btnNewGame = CreateNButton("btnNewGame","Neues Spiel: Start");
      $Self.btnNewGame.onclick = rtl.createCallback($Self,"btnNewGameClick");
      $Self.edtTextOut = CreateMemoEdit("edtTextOut");
      for (var $l1 = 0; $l1 <= 3; $l1++) {
        dir = $l1;
        $Self.FMovBtn[dir] = CreateSmallButton("btnMove" + pas.unt_GrueStewBase.CDirDesc[dir],pas.unt_GrueStewBase.CDirShortDesc[dir]);
        $Self.FMovBtn[dir].setAttribute("Dir",pas.SysUtils.IntToStr(dir));
        $Self.FMovBtn[dir].onclick = rtl.createCallback($Self,"onBtnMoveClick");
        $Self.FShtBtn[dir] = CreateSmallButton("btnShoot" + pas.unt_GrueStewBase.CDirDesc[dir],pas.unt_GrueStewBase.CDirShortDesc[dir]);
        $Self.FShtBtn[dir].setAttribute("Dir",pas.SysUtils.IntToStr(dir));
        $Self.FShtBtn[dir].onclick = rtl.createCallback($Self,"onBtnShootClick");
        $Self.FMapLbl[dir] = CreateLabel("lblMap" + pas.unt_GrueStewBase.CDirDesc[dir],"..");
      };
      $Self.lblActRoom = CreateLabel("lblActRoom","..");
      document.body.appendChild($Self.pnlMain);
      ltable = document.createElement("table");
      ltable.setAttribute("style","width: 100%");
      ltableRow = document.createElement("tr");
      ltableCell = document.createElement("td");
      ltableCell.setAttribute("style","width: 70%");
      $Self.pnlMain.appendChild(ltable);
      ltable.appendChild(ltableRow);
      ltableRow.appendChild(ltableCell);
      ltableCell.appendChild($Self.pnlStatus);
      ltableCell = document.createElement("td");
      ltableCell.setAttribute("style","width: 30%");
      ltableRow.appendChild(ltableCell);
      ltableCell.appendChild($Self.pnlInput);
      $Self.pnlStatus.appendChild($Self.btnNewGame);
      $Self.pnlStatus.appendChild(document.createElement("BR"));
      $Self.pnlStatus.appendChild($Self.edtTextOut);
      $Self.pnlInput.appendChild($Self.FMapLbl[0]);
      $Self.pnlInput.appendChild(document.createElement("BR"));
      $Self.pnlInput.appendChild($Self.FShtBtn[0]);
      $Self.pnlInput.appendChild(document.createElement("BR"));
      $Self.pnlInput.appendChild($Self.FMovBtn[0]);
      $Self.pnlInput.appendChild(document.createElement("BR"));
      $Self.pnlInput.appendChild($Self.FMapLbl[3]);
      $Self.pnlInput.appendChild($Self.FShtBtn[3]);
      $Self.pnlInput.appendChild($Self.FMovBtn[3]);
      $Self.pnlInput.appendChild($Self.lblActRoom);
      $Self.pnlInput.appendChild($Self.FMovBtn[1]);
      $Self.pnlInput.appendChild($Self.FShtBtn[1]);
      $Self.pnlInput.appendChild($Self.FMapLbl[1]);
      $Self.pnlInput.appendChild(document.createElement("BR"));
      $Self.pnlInput.appendChild($Self.FMovBtn[2]);
      $Self.pnlInput.appendChild(document.createElement("BR"));
      $Self.pnlInput.appendChild($Self.FShtBtn[2]);
      $Self.pnlInput.appendChild(document.createElement("BR"));
      $Self.pnlInput.appendChild($Self.FMapLbl[2]);
      $Self.Write($Self.fGrueStew.GetDescription(),true);
      return this;
    };
    this.btnNewGameClick = function (aEvent) {
      var Result = false;
      this.fGrueStew.NewGame();
      this.Write(this.fGrueStew.GetRoomDesc(),true);
      this.UpdateMap();
      return Result;
    };
    this.onBtnMoveClick = function (aEvent) {
      var Result = false;
      var lDir = 0;
      var lMResult = 0;
      if ((aEvent.target.tagName === "INPUT") && !this.fGrueStew.FGameEnded && pas.SysUtils.TryStrToInt(aEvent.target.getAttribute("Dir"),{get: function () {
          return lDir;
        }, set: function (v) {
          lDir = v;
        }})) {
        this.Write(pas.unt_GrueStewBase.ITryMove[lDir],false);
        lMResult = this.fGrueStew.Move(lDir);
        var $tmp1 = lMResult;
        if ($tmp1 === 0) {
          this.Write(this.fGrueStew.GetRoomDesc(),true)}
         else if ($tmp1 === 1) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"CantMoveThere"),false)}
         else if ($tmp1 === 2) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"ReachedExit"),false)}
         else if ($tmp1 === 3) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"ReachedExitwM"),false)}
         else if ($tmp1 === 4) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"CaughtBYMonster"),false)}
         else if ($tmp1 === 5) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"FellIntoPit"),false)}
         else if ($tmp1 === 6) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"BatCatchYou"),true);
          this.Write(this.fGrueStew.GetRoomDesc(),false);
        } else if ($tmp1 === 7) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"EQuake"),true);
          this.Write(this.fGrueStew.GetRoomDesc(),false);
        };
        this.UpdateMap();
      };
      return Result;
    };
    this.onBtnShootClick = function (aEvent) {
      var Result = false;
      var lDir = 0;
      var lSResult = 0;
      if ((aEvent.target.tagName === "INPUT") && !this.fGrueStew.FGameEnded && pas.SysUtils.TryStrToInt$1(aEvent.target.getAttribute("Dir"),{get: function () {
          return lDir;
        }, set: function (v) {
          lDir = v;
        }})) {
        this.Write(pas.unt_GrueStewBase.IShoot[lDir],false);
        lSResult = this.fGrueStew.Shoot(lDir);
        var $tmp1 = lSResult;
        if ($tmp1 === 0) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"HitMonster"),false)}
         else if ($tmp1 === 1) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"HitWall"),false)}
         else if ($tmp1 === 2) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"NoHit1"),false)}
         else if ($tmp1 === 3) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"NoHit2"),false)}
         else if ($tmp1 === 4) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"NoHit3"),false)}
         else if ($tmp1 === 5) {
          this.Write(rtl.getResStr(pas.unt_GrueStewBase,"EQuake"),true);
          this.Write(this.fGrueStew.GetRoomDesc(),false);
        };
        this.UpdateMap();
      };
      return Result;
    };
    this.UpdateMap = function () {
      var dir = 0;
      var lMapDir = 0;
      this.lblActRoom.textContent = pas.unt_GrueStewBase.RaumTxt2[this.fGrueStew.FPlayerRoom + 2];
      for (var $l1 = 0; $l1 <= 3; $l1++) {
        dir = $l1;
        lMapDir = this.fGrueStew.GetMap(dir);
        this.FMapLbl[dir].textContent = pas.unt_GrueStewBase.RaumTxt2[lMapDir + 2];
        this.FMovBtn[dir].disabled = lMapDir === -2;
        this.FShtBtn[dir].disabled = lMapDir === -2;
      };
    };
    this.Write = function (str, Clear) {
      if (Clear) this.edtTextOut.textContent = "";
      str = pas.SysUtils.StringReplace(str,"#","",rtl.createSet(0));
      this.edtTextOut.textContent = this.edtTextOut.textContent + pas.unt_GrueStewBase.LineEnding + str;
    };
  });
});
rtl.module("program",["System","JS","Classes","SysUtils","Web","Frw_GrueStewMain","unt_GrueStewBase","cls_GrueStewEng"],function () {
  "use strict";
  var $mod = this;
  $mod.$main = function () {
    pas.Frw_GrueStewMain.TFrwGrueStew.$create("Create$1");
  };
});
//# sourceMappingURL=jsGrueStew.js.map
