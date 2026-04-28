package sena.cafetin.controller;

import sena.cafetin.entity.HistorialEstadoPedido;
import sena.cafetin.service.HistorialEstadoPedidoService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/historial-estado-pedido")
public class HistorialEstadoPedidoController {
    private final HistorialEstadoPedidoService service;
    public HistorialEstadoPedidoController(HistorialEstadoPedidoService service) { this.service = service; }

    @GetMapping
    public List<HistorialEstadoPedido> getAll() { return service.findAll(); }

    @GetMapping("/{id}")
    public ResponseEntity<HistorialEstadoPedido> getById(@PathVariable Long id) {
        return service.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public HistorialEstadoPedido create(@RequestBody HistorialEstadoPedido historial) { return service.save(historial); }

    @PutMapping("/{id}")
    public ResponseEntity<HistorialEstadoPedido> update(@PathVariable Long id, @RequestBody HistorialEstadoPedido historial) {
        return service.findById(id).map(existing -> {
            historial.setId(id);
            return ResponseEntity.ok(service.save(historial));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}