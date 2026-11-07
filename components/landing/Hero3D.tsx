"use client";

import { useRef } from "react";
import { Canvas, useFrame } from "@react-three/fiber";
import { Float } from "@react-three/drei";
import type { Group } from "three";

/**
 * Koin emas 3D melayang + cincin emerald.
 * Ringan: geometri sederhana, tanpa texture, tanpa bayangan.
 */
function Coin({
  position,
  scale = 1,
  speed = 1,
}: {
  position: [number, number, number];
  scale?: number;
  speed?: number;
}) {
  const ref = useRef<Group>(null);
  useFrame((state) => {
    if (!ref.current) return;
    ref.current.rotation.y = state.clock.elapsedTime * 0.4 * speed;
    ref.current.rotation.x = Math.PI / 2.6 + Math.sin(state.clock.elapsedTime * 0.6 * speed) * 0.12;
  });
  return (
    <group ref={ref} position={position} scale={scale}>
      <mesh>
        <cylinderGeometry args={[1.05, 1.05, 0.14, 48]} />
        <meshStandardMaterial color="#d4af37" metalness={0.95} roughness={0.25} />
      </mesh>
      <mesh rotation={[Math.PI / 2, 0, 0]} position={[0, 0, 0.09]}>
        <torusGeometry args={[0.72, 0.045, 16, 64]} />
        <meshStandardMaterial color="#f5d76e" metalness={0.9} roughness={0.3} />
      </mesh>
      <mesh rotation={[Math.PI / 2, 0, 0]} position={[0, 0, -0.09]}>
        <torusGeometry args={[0.72, 0.045, 16, 64]} />
        <meshStandardMaterial color="#f5d76e" metalness={0.9} roughness={0.3} />
      </mesh>
    </group>
  );
}

function Scene() {
  const ringRef = useRef<Group>(null);
  useFrame((state) => {
    if (!ringRef.current) return;
    ringRef.current.rotation.z = state.clock.elapsedTime * 0.15;
    ringRef.current.rotation.x = Math.PI / 3 + Math.sin(state.clock.elapsedTime * 0.3) * 0.1;
  });

  return (
    <>
      <ambientLight intensity={0.6} />
      <directionalLight position={[5, 5, 5]} intensity={1.4} />
      <pointLight position={[-5, -2, 3]} intensity={12} color="#10b981" />
      <pointLight position={[4, -3, 2]} intensity={10} color="#f59e0b" />

      <Float speed={1.4} rotationIntensity={0.4} floatIntensity={0.9}>
        <Coin position={[0, 0.4, 0]} scale={1.15} speed={1} />
      </Float>
      <Float speed={1.8} rotationIntensity={0.6} floatIntensity={1.2}>
        <Coin position={[-2.2, -1.1, -0.8]} scale={0.7} speed={1.4} />
      </Float>
      <Float speed={1.2} rotationIntensity={0.5} floatIntensity={1}>
        <Coin position={[2.1, -0.9, -1]} scale={0.55} speed={0.8} />
      </Float>

      <group ref={ringRef} position={[0, 0.2, -1.2]}>
        <mesh>
          <torusGeometry args={[2.6, 0.03, 16, 100]} />
          <meshStandardMaterial color="#10b981" metalness={0.7} roughness={0.3} />
        </mesh>
      </group>

      {/* Partikel kecil */}
      {[
        [-1.6, 1.6, -1],
        [1.8, 1.4, -0.5],
        [-2.4, 0.4, 0],
        [2.5, 0.6, -0.6],
        [0.4, -1.8, -0.4],
      ].map((p, i) => (
        <mesh key={i} position={p as [number, number, number]}>
          <sphereGeometry args={[0.05, 16, 16]} />
          <meshStandardMaterial
            color={i % 2 === 0 ? "#fbbf24" : "#34d399"}
            metalness={0.8}
            roughness={0.3}
          />
        </mesh>
      ))}
    </>
  );
}

export default function Hero3D() {
  return (
    <div className="h-[320px] w-full sm:h-[420px] lg:h-[520px]" aria-hidden="true">
      <Canvas camera={{ position: [0, 0, 8.5], fov: 42 }} dpr={[1, 1.75]}>
        <Scene />
      </Canvas>
    </div>
  );
}
