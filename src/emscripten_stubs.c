/*
 * Emscripten stub implementations for GL/GLFW functions
 * not provided by LEGACY_GL_EMULATION or Emscripten's GLFW.
 */

#ifdef __EMSCRIPTEN__

#include <GLES/gl.h>
#include <GLFW/glfw3.h>

void glLightf(GLenum light, GLenum pname, GLfloat param) {
    (void)light; (void)pname; (void)param;
}

void glPointParameterfv(GLenum pname, const GLfloat* params) {
    (void)pname; (void)params;
}

void glShadeModel(GLenum mode) {
    (void)mode;
}

void glHint(GLenum target, GLenum mode) {
    (void)target; (void)mode;
}

int glfwGetGamepadState(int jid, GLFWgamepadstate* state) {
    (void)jid; (void)state;
    return 0;
}

#endif /* __EMSCRIPTEN__ */
