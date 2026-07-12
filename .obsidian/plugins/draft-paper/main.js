"use strict";
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);
var __publicField = (obj, key, value) => {
  __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
  return value;
};

// main.ts
var main_exports = {};
__export(main_exports, {
  default: () => DraftPaperPlugin
});
module.exports = __toCommonJS(main_exports);
var import_obsidian = require("obsidian");

// node_modules/perfect-freehand/dist/esm/index.mjs
var { PI: e } = Math;
var t = e + 1e-4;
var n = 0.5;
var r = [1, 1];
function i(e2, t2, n2, r2 = (e3) => e3) {
  return e2 * r2(0.5 - t2 * (0.5 - n2));
}
var { min: a } = Math;
function o(e2, t2, n2) {
  let r2 = a(1, t2 / n2);
  return a(1, e2 + (a(1, 1 - r2) - e2) * (r2 * 0.275));
}
function s(e2) {
  return [-e2[0], -e2[1]];
}
function c(e2, t2) {
  return [e2[0] + t2[0], e2[1] + t2[1]];
}
function l(e2, t2, n2) {
  return e2[0] = t2[0] + n2[0], e2[1] = t2[1] + n2[1], e2;
}
function u(e2, t2) {
  return [e2[0] - t2[0], e2[1] - t2[1]];
}
function d(e2, t2, n2) {
  return e2[0] = t2[0] - n2[0], e2[1] = t2[1] - n2[1], e2;
}
function f(e2, t2) {
  return [e2[0] * t2, e2[1] * t2];
}
function p(e2, t2, n2) {
  return e2[0] = t2[0] * n2, e2[1] = t2[1] * n2, e2;
}
function m(e2, t2) {
  return [e2[0] / t2, e2[1] / t2];
}
function h(e2) {
  return [e2[1], -e2[0]];
}
function g(e2, t2) {
  let n2 = t2[0];
  return e2[0] = t2[1], e2[1] = -n2, e2;
}
function ee(e2, t2) {
  return e2[0] * t2[0] + e2[1] * t2[1];
}
function _(e2, t2) {
  return e2[0] === t2[0] && e2[1] === t2[1];
}
function v(e2) {
  return Math.hypot(e2[0], e2[1]);
}
function y(e2, t2) {
  let n2 = e2[0] - t2[0], r2 = e2[1] - t2[1];
  return n2 * n2 + r2 * r2;
}
function b(e2) {
  return m(e2, v(e2));
}
function x(e2, t2) {
  return Math.hypot(e2[1] - t2[1], e2[0] - t2[0]);
}
function S(e2, t2, n2) {
  let r2 = Math.sin(n2), i2 = Math.cos(n2), a2 = e2[0] - t2[0], o2 = e2[1] - t2[1], s2 = a2 * i2 - o2 * r2, c2 = a2 * r2 + o2 * i2;
  return [s2 + t2[0], c2 + t2[1]];
}
function C(e2, t2, n2, r2) {
  let i2 = Math.sin(r2), a2 = Math.cos(r2), o2 = t2[0] - n2[0], s2 = t2[1] - n2[1], c2 = o2 * a2 - s2 * i2, l2 = o2 * i2 + s2 * a2;
  return e2[0] = c2 + n2[0], e2[1] = l2 + n2[1], e2;
}
function w(e2, t2, n2) {
  return c(e2, f(u(t2, e2), n2));
}
function te(e2, t2, n2, r2) {
  let i2 = n2[0] - t2[0], a2 = n2[1] - t2[1];
  return e2[0] = t2[0] + i2 * r2, e2[1] = t2[1] + a2 * r2, e2;
}
function T(e2, t2, n2) {
  return c(e2, f(t2, n2));
}
var E = [0, 0];
var D = [0, 0];
var O = [0, 0];
function k(e2, n2) {
  let r2 = T(e2, b(h(u(e2, c(e2, [1, 1])))), -n2), i2 = [], a2 = 1 / 13;
  for (let n3 = a2; n3 <= 1; n3 += a2)
    i2.push(S(r2, e2, t * 2 * n3));
  return i2;
}
function A(e2, n2, r2) {
  let i2 = [], a2 = 1 / r2;
  for (let r3 = a2; r3 <= 1; r3 += a2)
    i2.push(S(n2, e2, t * r3));
  return i2;
}
function j(e2, t2, n2) {
  let r2 = u(t2, n2), i2 = f(r2, 0.5), a2 = f(r2, 0.51);
  return [u(e2, i2), u(e2, a2), c(e2, a2), c(e2, i2)];
}
function M(e2, n2, r2, i2) {
  let a2 = [], o2 = T(e2, n2, r2), s2 = 1 / i2;
  for (let n3 = s2; n3 < 1; n3 += s2)
    a2.push(S(o2, e2, t * 3 * n3));
  return a2;
}
function ne(e2, t2, n2) {
  return [c(e2, f(t2, n2)), c(e2, f(t2, n2 * 0.99)), u(e2, f(t2, n2 * 0.99)), u(e2, f(t2, n2))];
}
function N(e2, t2, n2) {
  return e2 === false || e2 === void 0 ? 0 : e2 === true ? Math.max(t2, n2) : e2;
}
function re(e2, t2, n2) {
  return e2.slice(0, 10).reduce((e3, r2) => {
    let i2 = r2.pressure;
    return t2 && (i2 = o(e3, r2.distance, n2)), (e3 + i2) / 2;
  }, e2[0].pressure);
}
function P(e2, n2 = {}) {
  let { size: r2 = 16, smoothing: a2 = 0.5, thinning: f2 = 0.5, simulatePressure: m2 = true, easing: _2 = (e3) => e3, start: v2 = {}, end: b2 = {}, last: x2 = false } = n2, { cap: S2 = true, easing: w2 = (e3) => e3 * (2 - e3) } = v2, { cap: T2 = true, easing: P2 = (e3) => --e3 * e3 * e3 + 1 } = b2;
  if (e2.length === 0 || r2 <= 0)
    return [];
  let F2 = e2[e2.length - 1].runningLength, I2 = N(v2.taper, r2, F2), L2 = N(b2.taper, r2, F2), R2 = (r2 * a2) ** 2, z = [], B = [], V = re(e2, m2, r2), H = i(r2, f2, e2[e2.length - 1].pressure, _2), U, W = e2[0].vector, G = e2[0].point, K = G, q = G, J = K, Y = false;
  for (let n3 = 0; n3 < e2.length; n3++) {
    let { pressure: a3 } = e2[n3], { point: s2, vector: h2, distance: v3, runningLength: b3 } = e2[n3], x3 = n3 === e2.length - 1;
    if (!x3 && F2 - b3 < 3)
      continue;
    f2 ? (m2 && (a3 = o(V, v3, r2)), H = i(r2, f2, a3, _2)) : H = r2 / 2, U === void 0 && (U = H);
    let S3 = b3 < I2 ? w2(b3 / I2) : 1, T3 = F2 - b3 < L2 ? P2((F2 - b3) / L2) : 1;
    H = Math.max(0.01, H * Math.min(S3, T3));
    let k2 = (x3 ? e2[n3] : e2[n3 + 1]).vector, A2 = x3 ? 1 : ee(h2, k2), j2 = ee(h2, W) < 0 && !Y, M2 = A2 !== null && A2 < 0;
    if (j2 || M2) {
      g(E, W), p(E, E, H);
      for (let e3 = 0; e3 <= 1; e3 += 0.07692307692307693)
        d(D, s2, E), C(D, D, s2, t * e3), q = [D[0], D[1]], z.push(q), l(O, s2, E), C(O, O, s2, t * -e3), J = [O[0], O[1]], B.push(J);
      G = q, K = J, M2 && (Y = true);
      continue;
    }
    if (Y = false, x3) {
      g(E, h2), p(E, E, H), z.push(u(s2, E)), B.push(c(s2, E));
      continue;
    }
    te(E, k2, h2, A2), g(E, E), p(E, E, H), d(D, s2, E), q = [D[0], D[1]], (n3 <= 1 || y(G, q) > R2) && (z.push(q), G = q), l(O, s2, E), J = [O[0], O[1]], (n3 <= 1 || y(K, J) > R2) && (B.push(J), K = J), V = a3, W = h2;
  }
  let X = [e2[0].point[0], e2[0].point[1]], Z = e2.length > 1 ? [e2[e2.length - 1].point[0], e2[e2.length - 1].point[1]] : c(e2[0].point, [1, 1]), Q = [], $ = [];
  if (e2.length === 1) {
    if (!(I2 || L2) || x2)
      return k(X, U || H);
  } else {
    I2 || L2 && e2.length === 1 || (S2 ? Q.push(...A(X, B[0], 13)) : Q.push(...j(X, z[0], B[0])));
    let t2 = h(s(e2[e2.length - 1].vector));
    L2 || I2 && e2.length === 1 ? $.push(Z) : T2 ? $.push(...M(Z, t2, H, 29)) : $.push(...ne(Z, t2, H));
  }
  return z.concat($, B.reverse(), Q);
}
var F = [0, 0];
function I(e2) {
  return e2 != null && e2 >= 0;
}
function L(e2, t2 = {}) {
  var _a;
  let { streamline: i2 = 0.5, size: a2 = 16, last: o2 = false } = t2;
  if (e2.length === 0)
    return [];
  let s2 = 0.15 + (1 - i2) * 0.85, l2 = Array.isArray(e2[0]) ? e2 : e2.map(({ x: e3, y: t3, pressure: r2 = n }) => [e3, t3, r2]);
  if (l2.length === 2) {
    let e3 = l2[1];
    l2 = l2.slice(0, -1);
    for (let t3 = 1; t3 < 5; t3++)
      l2.push(w(l2[0], e3, t3 / 4));
  }
  l2.length === 1 && (l2 = [...l2, [...c(l2[0], r), ...l2[0].slice(2)]]);
  let u2 = [{ point: [l2[0][0], l2[0][1]], pressure: I(l2[0][2]) ? l2[0][2] : 0.25, vector: [...r], distance: 0, runningLength: 0 }], f2 = false, p2 = 0, m2 = u2[0], h2 = l2.length - 1;
  for (let e3 = 1; e3 < l2.length; e3++) {
    let t3 = o2 && e3 === h2 ? [l2[e3][0], l2[e3][1]] : w(m2.point, l2[e3], s2);
    if (_(m2.point, t3))
      continue;
    let r2 = x(t3, m2.point);
    if (p2 += r2, e3 < h2 && !f2) {
      if (p2 < a2)
        continue;
      f2 = true;
    }
    d(F, m2.point, t3), m2 = { point: t3, pressure: I(l2[e3][2]) ? l2[e3][2] : n, vector: b(F), distance: r2, runningLength: p2 }, u2.push(m2);
  }
  return u2[0].vector = ((_a = u2[1]) == null ? void 0 : _a.vector) || [0, 0], u2;
}
function R(e2, t2 = {}) {
  return P(L(e2, t2), t2);
}

// main.ts
var DEFAULT_COLOR = "#ff3333";
var DEFAULT_LINE_WIDTH = 2.5;
var HIGHLIGHTER_COLOR = "#ffeb3b";
var HIGHLIGHTER_OPACITY = 0.25;
var ERASER_HIT_DISTANCE = 15;
var PIXEL_ERASER_RADIUS = 16;
var FREEHAND_OPTIONS = {
  size: 1,
  thinning: 0.6,
  smoothing: 0.75,
  streamline: 0.65,
  simulatePressure: true,
  easing: (t2) => t2 * (2 - t2),
  start: { taper: 0, cap: true },
  end: { taper: 0, cap: true }
};
var BLOCK_SELECTORS = "p, h1, h2, h3, h4, h5, h6, li, blockquote, pre, .math-block, .callout";
function getBlockKey(el) {
  var _a;
  return ((_a = el.textContent) == null ? void 0 : _a.trim().substring(0, 60)) || "";
}
function dist(a2, b2) {
  return Math.hypot(a2.x - b2.x, a2.y - b2.y);
}
function clipStrokeByPixelEraser(stroke, eraserPoints, radius) {
  const erased = stroke.points.map(
    (p2) => eraserPoints.some((ep) => dist(p2, ep) < radius)
  );
  if (!erased.some(Boolean))
    return [stroke];
  const segments = [];
  let current = [];
  for (let i2 = 0; i2 < stroke.points.length; i2++) {
    if (!erased[i2]) {
      current.push({ ...stroke.points[i2] });
    } else {
      if (current.length >= 2) {
        segments.push({ ...stroke, points: current });
      }
      current = [];
    }
  }
  if (current.length >= 2) {
    segments.push({ ...stroke, points: current });
  }
  return segments;
}
var DraftPaperPlugin = class extends import_obsidian.Plugin {
  constructor() {
    super(...arguments);
    __publicField(this, "active", false);
    __publicField(this, "isDrawing", true);
    __publicField(this, "tool", "pen");
    __publicField(this, "eraserMode", "stroke");
    __publicField(this, "canvas", null);
    __publicField(this, "ctx", null);
    __publicField(this, "strokes", []);
    __publicField(this, "currentStroke", null);
    __publicField(this, "previewStroke", null);
    __publicField(this, "toolbar", null);
    __publicField(this, "eraserSubToolbar", null);
    __publicField(this, "eraserCursorEl", null);
    __publicField(this, "color", DEFAULT_COLOR);
    __publicField(this, "lineWidth", DEFAULT_LINE_WIDTH);
    __publicField(this, "opacity", 1);
    __publicField(this, "arrowStyle", "straight");
    __publicField(this, "eraserPath", []);
    __publicField(this, "isErasing", false);
    __publicField(this, "selectClearRect", null);
    __publicField(this, "selectClearStart", null);
    __publicField(this, "rafPending", false);
    __publicField(this, "currentFilePath", "");
    __publicField(this, "undoStack", []);
    __publicField(this, "redoStack", []);
    __publicField(this, "MAX_UNDO", 100);
    // ==================== 事件处理 ====================
    __publicField(this, "onPointerDown", (e2) => {
      if (!this.active || !this.isDrawing)
        return;
      if (e2.pointerType === "mouse" && e2.button !== 0)
        return;
      e2.preventDefault();
      const block = this.getBlockFromPoint(e2.clientX, e2.clientY);
      if (!block)
        return;
      const rect = block.getBoundingClientRect();
      const p2 = { x: e2.clientX - rect.left, y: e2.clientY - rect.top };
      if (this.tool === "hand")
        return;
      if (this.tool === "eraser") {
        if (this.eraserMode === "stroke") {
          this.eraseAt(block, p2, rect);
        } else if (this.eraserMode === "pixel") {
          this.isErasing = true;
          this.eraserPath = [p2];
          this.applyPixelEraser();
        } else if (this.eraserMode === "select-clear") {
          this.selectClearStart = p2;
          this.selectClearRect = { x1: p2.x, y1: p2.y, x2: p2.x, y2: p2.y };
        }
        return;
      }
      if (this.tool === "text") {
        this.textAt(block, p2);
        return;
      }
      if (this.tool === "pen" || this.tool === "highlighter") {
        this.currentStroke = {
          type: this.tool === "pen" ? "pen" : "highlighter",
          blockKey: getBlockKey(block),
          points: [p2],
          color: this.tool === "highlighter" ? HIGHLIGHTER_COLOR : this.color,
          lineWidth: this.lineWidth,
          opacity: this.tool === "highlighter" ? HIGHLIGHTER_OPACITY : this.opacity,
          timestamp: Date.now()
        };
      } else if (this.tool === "arrow" || this.tool === "rect") {
        this.previewStroke = {
          type: this.tool,
          blockKey: getBlockKey(block),
          points: [p2, p2],
          color: this.color,
          lineWidth: this.lineWidth,
          opacity: this.opacity,
          timestamp: Date.now(),
          arrowStyle: this.tool === "arrow" ? this.arrowStyle : void 0
        };
      }
      this.scheduleRedraw();
    });
    __publicField(this, "onPointerMove", (e2) => {
      if (!this.active || !this.isDrawing)
        return;
      const block = this.getBlockFromPoint(e2.clientX, e2.clientY);
      if (!block)
        return;
      const rect = block.getBoundingClientRect();
      const p2 = { x: e2.clientX - rect.left, y: e2.clientY - rect.top };
      if (this.tool === "eraser" && this.eraserMode === "pixel" && this.eraserCursorEl) {
        const size = PIXEL_ERASER_RADIUS * 2;
        this.eraserCursorEl.style.left = `${e2.clientX - PIXEL_ERASER_RADIUS}px`;
        this.eraserCursorEl.style.top = `${e2.clientY - PIXEL_ERASER_RADIUS}px`;
        this.eraserCursorEl.style.width = `${size}px`;
        this.eraserCursorEl.style.height = `${size}px`;
      }
      if (this.tool === "eraser") {
        if (this.eraserMode === "stroke" && e2.buttons === 1) {
          this.eraseAt(block, p2, rect);
        } else if (this.eraserMode === "pixel" && this.isErasing) {
          this.eraserPath.push(p2);
          this.applyPixelEraser();
        } else if (this.eraserMode === "select-clear" && this.selectClearRect) {
          this.selectClearRect.x2 = p2.x;
          this.selectClearRect.y2 = p2.y;
          this.scheduleRedraw();
        }
        return;
      }
      if (this.previewStroke) {
        if (getBlockKey(block) !== this.previewStroke.blockKey)
          return;
        this.previewStroke.points[1] = p2;
        this.scheduleRedraw();
        return;
      }
      if (!this.currentStroke)
        return;
      if (getBlockKey(block) !== this.currentStroke.blockKey)
        return;
      const last = this.currentStroke.points.at(-1);
      const filtered = {
        x: last.x + (p2.x - last.x) * 0.35,
        y: last.y + (p2.y - last.y) * 0.35
      };
      if (dist(filtered, last) < 1)
        return;
      this.currentStroke.points.push(filtered);
      this.scheduleRedraw();
    });
    __publicField(this, "onPointerUp", () => {
      if (!this.active || !this.isDrawing)
        return;
      if (this.tool === "eraser") {
        if (this.eraserMode === "pixel") {
          this.isErasing = false;
          this.eraserPath = [];
          this.saveStrokes();
        } else if (this.eraserMode === "select-clear" && this.selectClearRect) {
          this.pushUndo();
          this.deleteStrokesInRect(this.selectClearRect);
          this.selectClearRect = null;
          this.selectClearStart = null;
          this.scheduleRedraw();
          this.saveStrokes();
        }
        return;
      }
      if (this.previewStroke) {
        const [a2, b2] = this.previewStroke.points;
        if (dist(a2, b2) > 3) {
          this.pushUndo();
          this.strokes.push({ ...this.previewStroke });
        }
        this.previewStroke = null;
        this.scheduleRedraw();
        this.saveStrokes();
        return;
      }
      if (this.currentStroke) {
        if (this.currentStroke.points.length > 1) {
          this.pushUndo();
          this.strokes.push(this.currentStroke);
        }
        this.currentStroke = null;
        this.scheduleRedraw();
        this.saveStrokes();
        return;
      }
    });
    // ==================== 渲染 ====================
    __publicField(this, "scheduleRedraw", () => {
      if (!this.rafPending) {
        this.rafPending = true;
        requestAnimationFrame(() => {
          this.rafPending = false;
          this.syncCanvasSize();
          this.redraw();
        });
      }
    });
  }
  async onload() {
    this.addRibbonIcon("pencil", "\u8349\u7A3F\u7EB8", () => this.toggle());
    this.addCommand({ id: "toggle-draft", name: "\u5207\u6362\u8349\u7A3F\u7EB8", callback: () => this.toggle() });
    this.registerDomEvent(window, "scroll", this.scheduleRedraw, true);
    this.registerDomEvent(window, "resize", this.scheduleRedraw);
    this.registerEvent(this.app.workspace.on("active-leaf-change", () => {
      if (this.active)
        this.scheduleRedraw();
    }));
  }
  async onunload() {
    this.disable();
  }
  toggle() {
    if (this.active) {
      this.disable();
    } else {
      this.enable();
    }
  }
  enable() {
    var _a;
    if (this.active)
      return;
    const view = this.app.workspace.getActiveViewOfType(import_obsidian.MarkdownView);
    if (!view) {
      new import_obsidian.Notice("\u8BF7\u5148\u6253\u5F00\u4E00\u4E2A Markdown \u6587\u4EF6\u8FDB\u5165\u9605\u8BFB\u6A21\u5F0F");
      return;
    }
    if (view.getMode() !== "preview") {
      this.app.commands.executeCommandById("markdown:toggle-preview");
      setTimeout(() => this.enable(), 200);
      return;
    }
    this.currentFilePath = ((_a = view.file) == null ? void 0 : _a.path) || "";
    this.loadStrokes();
    this.init();
  }
  init() {
    const canvas = document.createElement("canvas");
    canvas.id = "draft-paper-canvas";
    Object.assign(canvas.style, {
      position: "fixed",
      top: "0",
      left: "0",
      width: "100vw",
      height: "100vh",
      zIndex: "5",
      pointerEvents: this.isDrawing ? "auto" : "none",
      touchAction: "none",
      background: "transparent"
    });
    document.body.appendChild(canvas);
    this.canvas = canvas;
    this.ctx = canvas.getContext("2d");
    this.syncCanvasSize();
    canvas.addEventListener("pointerdown", this.onPointerDown);
    canvas.addEventListener("pointermove", this.onPointerMove);
    canvas.addEventListener("pointerup", this.onPointerUp);
    canvas.addEventListener("pointerleave", this.onPointerUp);
    this.createToolbar();
    this.eraserCursorEl = document.createElement("div");
    this.eraserCursorEl.className = "draft-paper-eraser-cursor";
    this.eraserCursorEl.style.display = "none";
    document.body.appendChild(this.eraserCursorEl);
    this.active = true;
    this.isDrawing = true;
    this.tool = "pen";
    this.eraserMode = "stroke";
    this.updateModeUI();
    this.updateCursorVisibility();
    this.scheduleRedraw();
  }
  disable() {
    if (!this.active)
      return;
    this.saveStrokes();
    if (this.canvas) {
      this.canvas.removeEventListener("pointerdown", this.onPointerDown);
      this.canvas.removeEventListener("pointermove", this.onPointerMove);
      this.canvas.removeEventListener("pointerup", this.onPointerUp);
      this.canvas.removeEventListener("pointerleave", this.onPointerUp);
      this.canvas.remove();
      this.canvas = null;
      this.ctx = null;
    }
    if (this.toolbar) {
      this.toolbar.remove();
      this.toolbar = null;
    }
    if (this.eraserCursorEl) {
      this.eraserCursorEl.remove();
      this.eraserCursorEl = null;
    }
    this.strokes = [];
    this.currentStroke = null;
    this.active = false;
  }
  syncCanvasSize() {
    if (!this.canvas || !this.ctx)
      return;
    const dpr = window.devicePixelRatio || 1;
    this.canvas.width = window.innerWidth * dpr;
    this.canvas.height = window.innerHeight * dpr;
    this.canvas.style.width = `${window.innerWidth}px`;
    this.canvas.style.height = `${window.innerHeight}px`;
    this.ctx.setTransform(1, 0, 0, 1, 0, 0);
    this.ctx.scale(dpr, dpr);
  }
  // ==================== 工具栏 ====================
  createToolbar() {
    const bar = document.createElement("div");
    bar.id = "draft-paper-toolbar";
    bar.innerHTML = `
            <div class="dp-tool-group">
                <button data-t="pen" class="active" title="\u753B\u7B14 (1)">\u270F\uFE0F</button>
                <button data-t="highlighter" title="\u8367\u5149\u7B14 (2)">\u{1F58D}\uFE0F</button>
                <button data-t="eraser" title="\u6A61\u76AE\u64E6 (3)">\u{1F9F9}</button>
                <button data-t="arrow" title="\u7BAD\u5934 (4)">\u2197</button>
                <button data-t="rect" title="\u77E9\u5F62 (5)">\u2B1B</button>
                <button data-t="text" title="\u6587\u5B57 (6)">T</button>
                <button data-t="hand" title="\u624B\u638C (7)">\u{1F590}\uFE0F</button>
            </div>
            <div class="dp-style-group">
                <input type="color" id="dp-color" value="${this.color}" title="\u989C\u8272">
                <input type="range" id="dp-width" min="1" max="8" step="0.5" value="${this.lineWidth}" title="\u7C97\u7EC6">
                <span id="dp-wlbl">${this.lineWidth}px</span>
                <input type="range" id="dp-opacity" min="10" max="100" value="${this.opacity * 100}" title="\u900F\u660E\u5EA6">
                <span id="dp-olbl">${Math.round(this.opacity * 100)}%</span>
                <select id="dp-arrow-style" style="display:none">
                    <option value="straight" selected>\u2192</option>
                    <option value="curved">\u219D</option>
                    <option value="dashed">\u21E2</option>
                    <option value="double">\u2194</option>
                </select>
            </div>
            <div class="dp-mode-group">
                <button id="dp-mode" class="dp-text-btn">\u{1F7E2} \u7ED8\u56FE</button>
                <button id="dp-undo" title="\u64A4\u9500 (Ctrl+Z)">\u21A9</button>
                <button id="dp-redo" title="\u91CD\u505A (Ctrl+Shift+Z)">\u21AA</button>
                <button id="dp-clear" title="\u6E05\u7A7A\u753B\u5E03">\u{1F5D1}</button>
                <button id="dp-exit" title="\u9000\u51FA\u8349\u7A3F\u7EB8">\u274C</button>
            </div>
        `;
    document.body.appendChild(bar);
    this.toolbar = bar;
    this.eraserSubToolbar = document.createElement("div");
    this.eraserSubToolbar.className = "draft-paper-eraser-subtoolbar";
    this.eraserSubToolbar.innerHTML = `
            <button data-eraser="pixel" title="\u5C40\u90E8\u64E6\u9664">\u5C40\u90E8\u64E6\u9664</button>
            <button data-eraser="stroke" class="active" title="\u6574\u7B14\u64E6\u9664">\u6574\u7B14\u64E6\u9664</button>
            <button data-eraser="select-clear" title="\u6846\u9009\u5220\u9664">\u6846\u9009\u5220\u9664</button>
        `;
    this.eraserSubToolbar.style.display = "none";
    this.toolbar.appendChild(this.eraserSubToolbar);
    bar.querySelectorAll("[data-t]").forEach((btn) => {
      btn.addEventListener("click", (e2) => {
        e2.stopPropagation();
        const tool = btn.dataset.t;
        if (tool === "eraser") {
          const wasVisible = this.eraserSubToolbar.style.display !== "none";
          this.eraserSubToolbar.style.display = wasVisible ? "none" : "flex";
          if (!wasVisible && this.tool !== "eraser") {
            this.eraserMode = "stroke";
          }
          this.tool = "eraser";
          this.resetToolState();
          this.updateCursorVisibility();
          this.updateEraserSubToolbarActive();
        } else {
          this.eraserSubToolbar.style.display = "none";
          this.tool = tool;
          this.eraserMode = "stroke";
          if (tool === "hand") {
            this.canvas.style.pointerEvents = "none";
          } else if (this.isDrawing) {
            this.canvas.style.pointerEvents = "auto";
          }
          this.resetToolState();
          this.updateCursorVisibility();
        }
        this.updateToolbarActive();
      });
    });
    this.eraserSubToolbar.querySelectorAll("[data-eraser]").forEach((btn) => {
      btn.addEventListener("click", (e2) => {
        e2.stopPropagation();
        const mode = btn.dataset.eraser;
        this.eraserMode = mode;
        this.resetToolState();
        this.updateCursorVisibility();
        this.updateEraserSubToolbarActive();
        this.eraserSubToolbar.style.display = "none";
      });
    });
    document.getElementById("dp-mode").onclick = () => this.toggleDrawMode();
    document.getElementById("dp-undo").onclick = () => this.undo();
    document.getElementById("dp-redo").onclick = () => this.redo();
    document.getElementById("dp-clear").onclick = () => this.confirmClearAll();
    document.getElementById("dp-exit").onclick = () => this.disable();
    document.getElementById("dp-color").addEventListener("input", (e2) => {
      this.color = e2.target.value;
    });
    document.getElementById("dp-width").addEventListener("input", (e2) => {
      this.lineWidth = parseFloat(e2.target.value);
      document.getElementById("dp-wlbl").textContent = `${this.lineWidth}px`;
    });
    document.getElementById("dp-opacity").addEventListener("input", (e2) => {
      this.opacity = parseInt(e2.target.value) / 100;
      document.getElementById("dp-olbl").textContent = `${Math.round(this.opacity * 100)}%`;
    });
    document.getElementById("dp-arrow-style").addEventListener("change", (e2) => {
      this.arrowStyle = e2.target.value;
    });
  }
  updateToolbarActive() {
    var _a;
    (_a = this.toolbar) == null ? void 0 : _a.querySelectorAll("[data-t]").forEach((btn) => {
      btn.classList.toggle("active", btn.dataset.t === this.tool);
    });
    const arrowSelect = document.getElementById("dp-arrow-style");
    if (arrowSelect)
      arrowSelect.style.display = this.tool === "arrow" ? "inline" : "none";
  }
  updateEraserSubToolbarActive() {
    var _a;
    (_a = this.eraserSubToolbar) == null ? void 0 : _a.querySelectorAll("[data-eraser]").forEach((btn) => {
      btn.classList.toggle("active", btn.dataset.eraser === this.eraserMode);
    });
  }
  toggleDrawMode() {
    this.isDrawing = !this.isDrawing;
    if (this.canvas) {
      this.canvas.style.pointerEvents = this.isDrawing ? "auto" : "none";
      this.canvas.style.cursor = this.isDrawing ? "crosshair" : "default";
    }
    this.updateModeUI();
  }
  updateModeUI() {
    const btn = document.getElementById("dp-mode");
    if (!btn)
      return;
    btn.textContent = this.isDrawing ? "\u{1F7E2} \u7ED8\u56FE" : "\u{1F441} \u9605\u8BFB";
    if (!this.isDrawing)
      btn.classList.add("active");
    else
      btn.classList.remove("active");
  }
  updateCursorVisibility() {
    if (this.eraserCursorEl) {
      const show = this.tool === "eraser" && this.eraserMode === "pixel";
      this.eraserCursorEl.style.display = show ? "block" : "none";
    }
  }
  resetToolState() {
    this.currentStroke = null;
    this.previewStroke = null;
    this.eraserPath = [];
    this.isErasing = false;
    this.selectClearRect = null;
    this.selectClearStart = null;
    this.scheduleRedraw();
  }
  // ==================== 穿透 canvas 获取块元素 ====================
  getBlockFromPoint(x2, y2) {
    if (!this.canvas)
      return null;
    const prevPE = this.canvas.style.pointerEvents;
    this.canvas.style.pointerEvents = "none";
    const elem = document.elementFromPoint(x2, y2);
    this.canvas.style.pointerEvents = prevPE;
    if (!elem)
      return null;
    return elem.closest(BLOCK_SELECTORS);
  }
  // ==================== 橡皮实现 ====================
  eraseAt(block, p2, rect) {
    this.pushUndo();
    const key = getBlockKey(block);
    this.strokes = this.strokes.filter((s2) => {
      if (s2.blockKey !== key)
        return true;
      const absPts = s2.points.map((pt) => ({ x: pt.x + rect.left, y: pt.y + rect.top }));
      return !absPts.some((apt) => dist(apt, { x: p2.x + rect.left, y: p2.y + rect.top }) < ERASER_HIT_DISTANCE);
    });
    this.scheduleRedraw();
    this.saveStrokes();
  }
  applyPixelEraser() {
    if (this.eraserPath.length === 0)
      return;
    const newStrokes = [];
    for (const s2 of this.strokes) {
      const clipped = clipStrokeByPixelEraser(s2, this.eraserPath, PIXEL_ERASER_RADIUS);
      newStrokes.push(...clipped);
    }
    this.strokes = newStrokes;
    this.scheduleRedraw();
  }
  deleteStrokesInRect(rect) {
    const minX = Math.min(rect.x1, rect.x2);
    const maxX = Math.max(rect.x1, rect.x2);
    const minY = Math.min(rect.y1, rect.y2);
    const maxY = Math.max(rect.y1, rect.y2);
    const blockMap = /* @__PURE__ */ new Map();
    document.querySelectorAll(BLOCK_SELECTORS).forEach((el) => {
      const key = getBlockKey(el);
      if (key)
        blockMap.set(key, el.getBoundingClientRect());
    });
    this.strokes = this.strokes.filter((s2) => {
      const blockRect = blockMap.get(s2.blockKey);
      if (!blockRect)
        return true;
      return !s2.points.some((pt) => {
        const absX = pt.x + blockRect.left;
        const absY = pt.y + blockRect.top;
        return absX >= minX && absX <= maxX && absY >= minY && absY <= maxY;
      });
    });
  }
  // ==================== 文字工具 ====================
  textAt(block, p2) {
    const rect = block.getBoundingClientRect();
    const input = document.createElement("textarea");
    Object.assign(input.style, {
      position: "fixed",
      left: `${rect.left + p2.x}px`,
      top: `${rect.top + p2.y}px`,
      zIndex: "10002",
      minWidth: "80px",
      border: "1px dashed var(--interactive-accent)",
      background: "var(--background-primary)",
      padding: "4px",
      fontSize: "16px",
      resize: "both"
    });
    document.body.appendChild(input);
    input.focus();
    const done = () => {
      const text = input.value.trim();
      input.remove();
      if (text) {
        this.pushUndo();
        this.strokes.push({
          type: "text",
          blockKey: getBlockKey(block),
          points: [p2],
          color: this.color,
          lineWidth: this.lineWidth,
          opacity: this.opacity,
          timestamp: Date.now(),
          text,
          fontSize: 16
        });
        this.saveStrokes();
        this.scheduleRedraw();
      }
    };
    input.addEventListener("blur", done);
    input.addEventListener("keydown", (e2) => {
      if (e2.key === "Escape")
        input.remove();
      else if (e2.key === "Enter" && !e2.shiftKey) {
        e2.preventDefault();
        done();
      }
    });
  }
  // ==================== 清空 ====================
  clearAll() {
    if (this.strokes.length === 0)
      return;
    this.pushUndo();
    this.strokes = [];
    this.scheduleRedraw();
    this.saveStrokes();
    new import_obsidian.Notice("\u753B\u5E03\u5DF2\u6E05\u7A7A\uFF0C\u53EF\u6309 Ctrl+Z \u6062\u590D");
  }
  confirmClearAll() {
    const modal = new import_obsidian.Modal(this.app);
    modal.titleEl.setText("\u786E\u8BA4\u6E05\u7A7A");
    modal.contentEl.createEl("p", { text: "\u6E05\u7A7A\u5F53\u524D\u6587\u4EF6\u6240\u6709\u6279\u6CE8\uFF1F" });
    const btns = modal.contentEl.createDiv();
    btns.createEl("button", { text: "\u786E\u8BA4" }).addEventListener("click", () => {
      this.clearAll();
      modal.close();
    });
    btns.createEl("button", { text: "\u53D6\u6D88" }).addEventListener("click", () => modal.close());
    modal.open();
  }
  redraw() {
    if (!this.ctx || !this.canvas)
      return;
    const dpr = window.devicePixelRatio || 1;
    this.ctx.clearRect(0, 0, this.canvas.width / dpr, this.canvas.height / dpr);
    const blockMap = /* @__PURE__ */ new Map();
    document.querySelectorAll(BLOCK_SELECTORS).forEach((el) => {
      const key = getBlockKey(el);
      if (key)
        blockMap.set(key, el.getBoundingClientRect());
    });
    for (const s2 of this.strokes) {
      const rect = blockMap.get(s2.blockKey);
      if (rect)
        this.drawStroke(s2, rect);
    }
    if (this.currentStroke) {
      const rect = blockMap.get(this.currentStroke.blockKey);
      if (rect)
        this.drawStroke(this.currentStroke, rect);
    }
    if (this.previewStroke) {
      const rect = blockMap.get(this.previewStroke.blockKey);
      if (rect)
        this.drawStroke(this.previewStroke, rect);
    }
    if (this.selectClearRect && this.tool === "eraser" && this.eraserMode === "select-clear") {
      const anyBlock = document.querySelector(BLOCK_SELECTORS);
      if (anyBlock) {
        const bRect = anyBlock.getBoundingClientRect();
        const absRect = {
          x1: this.selectClearRect.x1 + bRect.left,
          y1: this.selectClearRect.y1 + bRect.top,
          x2: this.selectClearRect.x2 + bRect.left,
          y2: this.selectClearRect.y2 + bRect.top
        };
        this.ctx.save();
        this.ctx.strokeStyle = "#ff6666";
        this.ctx.lineWidth = 1.5;
        this.ctx.setLineDash([6, 3]);
        this.ctx.strokeRect(
          Math.min(absRect.x1, absRect.x2),
          Math.min(absRect.y1, absRect.y2),
          Math.abs(absRect.x2 - absRect.x1),
          Math.abs(absRect.y2 - absRect.y1)
        );
        this.ctx.setLineDash([]);
        this.ctx.restore();
      }
    }
  }
  drawStroke(stroke, blockRect) {
    if (!this.ctx || stroke.points.length < 1)
      return;
    const absPts = stroke.points.map((p2) => ({ x: p2.x + blockRect.left, y: p2.y + blockRect.top }));
    if (stroke.type === "pen" || stroke.type === "highlighter") {
      const outline = R(
        absPts.map((p2) => [p2.x, p2.y]),
        { ...FREEHAND_OPTIONS, size: stroke.lineWidth * 2.2 }
      );
      if (!outline.length)
        return;
      const ctx = this.ctx;
      ctx.save();
      if (stroke.type === "highlighter")
        ctx.globalCompositeOperation = "multiply";
      ctx.globalAlpha = stroke.opacity;
      ctx.fillStyle = stroke.color;
      ctx.beginPath();
      ctx.moveTo(outline[0][0], outline[0][1]);
      for (let i2 = 1; i2 < outline.length; i2++)
        ctx.lineTo(outline[i2][0], outline[i2][1]);
      ctx.closePath();
      ctx.fill();
      ctx.restore();
    } else if (stroke.type === "arrow") {
      this.drawArrowStroke(stroke, blockRect);
    } else if (stroke.type === "rect") {
      const [a2, b2] = absPts;
      const ctx = this.ctx;
      ctx.save();
      ctx.strokeStyle = stroke.color;
      ctx.lineWidth = stroke.lineWidth;
      ctx.globalAlpha = stroke.opacity;
      ctx.strokeRect(Math.min(a2.x, b2.x), Math.min(a2.y, b2.y), Math.abs(b2.x - a2.x), Math.abs(b2.y - a2.y));
      ctx.restore();
    } else if (stroke.type === "text") {
      const pt = absPts[0];
      const ctx = this.ctx;
      ctx.save();
      ctx.fillStyle = stroke.color;
      ctx.globalAlpha = stroke.opacity;
      ctx.font = `${stroke.fontSize || 16}px sans-serif`;
      ctx.fillText(stroke.text || "", pt.x, pt.y);
      ctx.restore();
    }
  }
  drawArrowStroke(stroke, blockRect) {
    if (!this.ctx)
      return;
    const [a2, b2] = stroke.points.map((p2) => ({ x: p2.x + blockRect.left, y: p2.y + blockRect.top }));
    const style = stroke.arrowStyle || "straight";
    const ctx = this.ctx;
    ctx.save();
    ctx.strokeStyle = stroke.color;
    ctx.lineWidth = stroke.lineWidth;
    ctx.globalAlpha = stroke.opacity;
    ctx.lineCap = "round";
    ctx.lineJoin = "round";
    if (style === "dashed")
      ctx.setLineDash([8, 4]);
    ctx.beginPath();
    if (style === "curved") {
      const cx = (a2.x + b2.x) / 2 + (b2.y - a2.y) * 0.2;
      const cy = (a2.y + b2.y) / 2 - (b2.x - a2.x) * 0.2;
      ctx.moveTo(a2.x, a2.y);
      ctx.quadraticCurveTo(cx, cy, b2.x, b2.y);
    } else {
      ctx.moveTo(a2.x, a2.y);
      ctx.lineTo(b2.x, b2.y);
    }
    ctx.stroke();
    ctx.setLineDash([]);
    const headSize = Math.max(6, stroke.lineWidth * 4);
    this.drawArrowHead(ctx, a2, b2, stroke.color, headSize);
    if (style === "double")
      this.drawArrowHead(ctx, b2, a2, stroke.color, headSize);
    ctx.restore();
  }
  drawArrowHead(ctx, from, to, color, size) {
    const angle = Math.atan2(to.y - from.y, to.x - from.x);
    ctx.save();
    ctx.fillStyle = color;
    ctx.beginPath();
    ctx.moveTo(to.x, to.y);
    ctx.lineTo(
      to.x - size * Math.cos(angle - Math.PI / 6),
      to.y - size * Math.sin(angle - Math.PI / 6)
    );
    ctx.lineTo(
      to.x - size * Math.cos(angle + Math.PI / 6),
      to.y - size * Math.sin(angle + Math.PI / 6)
    );
    ctx.closePath();
    ctx.fill();
    ctx.restore();
  }
  // ==================== 存储 ====================
  getDraftDir() {
    if (!this.currentFilePath)
      return "";
    const idx = this.currentFilePath.lastIndexOf("/");
    const dir = idx >= 0 ? this.currentFilePath.substring(0, idx) : "";
    return dir ? `${dir}/draft-paper` : "draft-paper";
  }
  getDraftFileName() {
    if (!this.currentFilePath)
      return "";
    const idx = this.currentFilePath.lastIndexOf("/");
    const name = idx >= 0 ? this.currentFilePath.substring(idx + 1) : this.currentFilePath;
    return name.replace(/\.md$/i, ".json");
  }
  async loadStrokes() {
    if (!this.currentFilePath) {
      this.strokes = [];
      return;
    }
    const path = `${this.getDraftDir()}/${this.getDraftFileName()}`;
    try {
      this.strokes = JSON.parse(await this.app.vault.adapter.read(path));
    } catch (e2) {
      this.strokes = [];
    }
  }
  async saveStrokes() {
    if (!this.currentFilePath)
      return;
    const path = `${this.getDraftDir()}/${this.getDraftFileName()}`;
    try {
      await this.app.vault.adapter.mkdir(this.getDraftDir());
    } catch (e2) {
    }
    try {
      await this.app.vault.adapter.write(path, JSON.stringify(this.strokes));
    } catch (err) {
      console.error("\u8349\u7A3F\u4FDD\u5B58\u5931\u8D25:", err);
    }
  }
  // ==================== 撤销/重做 ====================
  pushUndo() {
    this.undoStack.push(JSON.parse(JSON.stringify(this.strokes)));
    if (this.undoStack.length > this.MAX_UNDO)
      this.undoStack.shift();
    this.redoStack = [];
  }
  undo() {
    if (this.undoStack.length === 0)
      return;
    this.redoStack.push(JSON.parse(JSON.stringify(this.strokes)));
    this.strokes = this.undoStack.pop();
    this.scheduleRedraw();
    this.saveStrokes();
  }
  redo() {
    if (this.redoStack.length === 0)
      return;
    this.undoStack.push(JSON.parse(JSON.stringify(this.strokes)));
    this.strokes = this.redoStack.pop();
    this.scheduleRedraw();
    this.saveStrokes();
  }
};

/* nosourcemap */